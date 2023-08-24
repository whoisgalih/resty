import 'package:flutter/material.dart';
import 'package:resty/models/restautrant_model.dart';
import 'package:resty/themes/colors.dart';

class RestaurantPage extends StatefulWidget {
  final Restaurant restaurant;
  final double expandedHeight;

  static String routeName = '/restaurant_page';

  const RestaurantPage({
    super.key,
    required this.restaurant,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
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
                  widget.restaurant.name,
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
                      tag: widget.restaurant.id,
                      child: Image.network(
                        widget.restaurant.pictureId,
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
            )
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
                  _heading("About"),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isTextExpanded = !_isTextExpanded;
                      });
                    },
                    child: Text(
                      widget.restaurant.description,
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
                                widget.restaurant.city,
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
                                widget.restaurant.rating.toString(),
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
                    children: widget.restaurant.menus.foods
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
                    children: widget.restaurant.menus.drinks
                        .map(
                          (drink) => Text(
                            "• ${drink.name}",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                        .toList(),
                  )
                ],
              ),
            ),
          ),
        ),
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
}
