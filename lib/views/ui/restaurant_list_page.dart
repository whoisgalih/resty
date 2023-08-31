// import 'package:flutter/material.dart';
// import 'package:resty/data/models/restaurant_list.dart';
// import 'package:resty/themes/colors.dart';
// import 'package:resty/views/widgets/list_view_item.dart';
// import 'package:resty/views/widgets/persistent_header.dart';
// import 'package:resty/views/widgets/resty_app_bar.dart';
// import 'package:resty/views/widgets/select_button.dart';
// import 'package:resty/views/widgets/resty_search_bar.dart';
// import 'package:resty/views/widgets/small_button.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resty/commons/result_state.dart';
import 'package:resty/provider/restaurants_provider.dart';
import 'package:resty/themes/colors.dart';
import 'package:resty/views/widgets/filter_bar.dart';
import 'package:resty/views/widgets/list_view_item.dart';
import 'package:resty/views/widgets/resty_app_bar.dart';
import 'package:resty/views/widgets/resty_search_bar.dart';

class RestaurantListPage extends StatelessWidget {
  static const routeName = '/restaurant_list';

  const RestaurantListPage({super.key});

  Widget _buildList(BuildContext context, RestaurantsProvider state) {
    if (state.state == ResultState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state.state == ResultState.hasData) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: state.restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = state.restaurants[index];
          return ListViewItem(restaurant: restaurant);
        },
      );
    } else if (state.state == ResultState.noData) {
      return _displayError(
        icon: Icons.search_off,
        text: RichText(
          text: TextSpan(
            text: state.message,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            children: [
              TextSpan(
                text: " not found in restaurants list",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      );
    } else if (state.state == ResultState.error) {
      return _displayError(
        icon: Icons.error_outline,
        text: Text(
          // "Oops, something went wrong\nFailed to load restaurants",
          state.message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    } else {
      return const Center(
        child: Text(""),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantsProvider>(
        builder: (BuildContext context, RestaurantsProvider state, _) {
          return NestedScrollView(
            headerSliverBuilder: (context, isScrolled) {
              return [
                const RestyAppBar(),
                state.state == ResultState.hasData ||
                        (state.isSearching && state.state != ResultState.error)
                    ? const RestySearchBar()
                    : const SliverToBoxAdapter(child: SizedBox()),
                state.state == ResultState.hasData ||
                        (state.isSearching && state.state != ResultState.error)
                    ? FilterBar()
                    : const SliverToBoxAdapter(child: SizedBox()),
              ];
            },
            body: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: _buildList(context, state),
            ),
          );
        },
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
