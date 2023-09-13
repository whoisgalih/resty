import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resty/commons/result_state.dart';
import 'package:resty/data/api/api_service.dart';
import 'package:resty/data/models/customer_review/cutomer_review_model.dart';
import 'package:resty/provider/database_provider.dart';
import 'package:resty/provider/restaurant_provider.dart';
import 'package:resty/themes/colors.dart';
import 'package:resty/views/ui/add_review_page.dart';
import 'package:resty/views/widgets/display_error.dart';

class RestaurantPage extends StatelessWidget {
  static String routeName = '/restaurant_page';

  const RestaurantPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (BuildContext context, RestaurantProvider state, _) {
        return Scaffold(
          floatingActionButton: state.state == ResultState.hasData
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AddReviewPage.routeName,
                      arguments: Provider.of<RestaurantProvider>(context,
                              listen: false)
                          .restaurant
                          .id,
                    ).then(
                      (result) {
                        if (result is List<CustomerReview>) {
                          Provider.of<RestaurantProvider>(context,
                                  listen: false)
                              .setReviews(result);
                        }
                      },
                    );
                  },
                  child: const Icon(Icons.chat_rounded),
                )
              : null,
          body: NestedScrollView(
            controller: state.scrollController,
            headerSliverBuilder: (context, isScrolled) {
              return [
                SliverAppBar(
                  actions: [
                    Consumer<DatabaseProvider>(
                      builder:
                          (BuildContext context, DatabaseProvider provider, _) {
                        return FutureBuilder(
                          future: provider.isFavorite(state.restaurant.id),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            bool isFavorite = snapshot.data ?? false;
                            if (isFavorite) {
                              return IconButton(
                                onPressed: () {
                                  provider.removeFavorite(state.restaurant.id);
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: accentColor[500],
                                ),
                              );
                            } else {
                              return IconButton(
                                onPressed: () {
                                  provider.addFavorite(state.restaurant);
                                },
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: state.isExpanded
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onPrimary,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                    // const SizedBox(width: 16),
                  ],
                  expandedHeight: 300,
                  pinned: true,
                  foregroundColor: state.isExpanded
                      ? Colors.white
                      : Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      state.restaurant.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: state.isExpanded
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
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 300,
                              width: double.infinity,
                              color: primaryColor[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.white,
                              ),
                            ),
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _heading(context, "About"),
                      GestureDetector(
                        onTap: () {
                          state.isTextExpanded = !state.isTextExpanded;
                        },
                        child: Text(
                          state.restaurant.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: primaryColor[400]),
                          maxLines: state.isTextExpanded ? null : 5,
                          overflow: state.isTextExpanded
                              ? null
                              : TextOverflow.ellipsis,
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
                                    state.restaurant.city,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
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
                                    state.restaurant.rating.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
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
                      ..._buildDetail(context, state),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildDetail(BuildContext context, RestaurantProvider state) {
    if (state.state == ResultState.loading) {
      return [
        const SizedBox(
          height: 300,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ];
    }

    if (state.state == ResultState.hasData) {
      return [
        _heading(context, "Menu"),
        _heading(
          context,
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
          context,
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
        _heading(context, "Reviews"),
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
      ];
    }

    return [
      DisplayError(
        icon: Icons.error_outline,
        text: Text(
          state.message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      )
    ];
  }

  Padding _heading(BuildContext context, String text,
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
}
