import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resty/commons/result_state.dart';
import 'package:resty/data/api/api_service.dart';
import 'package:resty/data/models/customer_review/cutomer_review_model.dart';
import 'package:resty/provider/restaurant_detail_provider.dart';
import 'package:resty/themes/colors.dart';
import 'package:resty/views/ui/add_review_page.dart';

class RestaurantPage extends StatefulWidget {
  final double expandedHeight;

  static String routeName = '/restaurant_page';

  const RestaurantPage({
    super.key,
    this.expandedHeight = 300,
  });

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  late ScrollController _scrollController;
  bool _isExpanded = true;
  bool _isTextExpanded = false;

  void _isExpandedFunction() {
    setState(() {
      _isExpanded = _scrollController.hasClients &&
          _scrollController.offset < (widget.expandedHeight - kToolbarHeight);
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_isExpandedFunction);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_isExpandedFunction);
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildDetail(BuildContext context, RestaurantProvider state) {
    if (state.state == ResultState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.state == ResultState.hasData) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _heading("About"),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isTextExpanded = !_isTextExpanded;
                  });
                },
                child: Text(
                  state.result.restaurant.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: primaryColor[400]),
                  maxLines: _isTextExpanded ? null : 5,
                  overflow: _isTextExpanded ? null : TextOverflow.ellipsis,
                ),
              ),
              Divider(
                height: 33,
                thickness: 1,
                color: primaryColor[200],
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.result.restaurant.city,
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 33,
                      thickness: 1,
                      color: primaryColor[200],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.result.restaurant.rating.toString(),
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 33,
                thickness: 1,
                color: primaryColor[200],
              ),
              _heading("Menu"),
              _heading(
                "Food",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                bottom: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: state.result.restaurant.menus.foods
                    .map(
                      (food) => Text(
                        "• ${food.name}",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                    .toList(),
              ),
              _heading(
                "Drinks",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                bottom: 8,
                top: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: state.result.restaurant.menus.drinks
                    .map(
                      (drink) => Text(
                        "• ${drink.name}",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                    .toList(),
              ),
              Divider(
                height: 33,
                thickness: 1,
                color: primaryColor[200],
              ),
              _heading("Reviews"),
              Column(
                children: state.result.restaurant.customerReviews
                    .map(
                      (review) => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review.review,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              review.date.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(color: primaryColor[400]),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      );
    }

    return _displayError(
      icon: Icons.error_outline,
      text: Text(
        // "Oops, something went wrong\nFailed to load restaurants",
        state.message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AddReviewPage.routeName,
            arguments: Provider.of<RestaurantProvider>(context, listen: false)
                .restaurant
                .id,
          ).then((result) {
            if (result is List<CustomerReview>) {
              Provider.of<RestaurantProvider>(context, listen: false)
                  .setReviews(result);
            }
          });
        },
        child: const Icon(Icons.chat_rounded),
      ),
      body: Consumer<RestaurantProvider>(
        builder: (BuildContext context, RestaurantProvider state, _) {
          return NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, isScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: widget.expandedHeight,
                  pinned: true,
                  foregroundColor: _isExpanded
                      ? Colors.white
                      : Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      state.restaurant.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: _isExpanded
                                ? Colors.white
                                : Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: state.restaurant.id,
                          child: Image.network(
                            "${ApiService.baseUrl}/images/large/${state.restaurant.pictureId}",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.0, 0.5),
                              end: Alignment.center,
                              colors: <Color>[
                                Color(0x60000000),
                                Color(0x00000000),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: _buildDetail(context, state)),
          );
        },
      ),
    );
  }

  Padding _heading(String text,
      {TextStyle? style, double? bottom, double? top}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? 16, top: top ?? 0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: style ??
            Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Column _displayError({
    required IconData icon,
    required Widget text,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 100,
          color: primaryColor[300],
        ),
        const SizedBox(height: 24),
        text,
      ],
    );
  }
}
