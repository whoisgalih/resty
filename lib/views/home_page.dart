import 'package:flutter/material.dart';
import 'package:resty/models/restaurant_list.dart';
import 'package:resty/views/widgets/list_view_item.dart';
import 'package:resty/views/widgets/persistent_header.dart';
import 'package:resty/views/widgets/resty_app_bar.dart';
import 'package:resty/views/widgets/select_button.dart';
import 'package:resty/views/widgets/resty_search_bar.dart';
import 'package:resty/views/widgets/small_button.dart';

enum LoadState {
  loading,
  success,
  error,
}

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/restaurant_list';

  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  late Restaurants restaurants;
  LoadState loadState = LoadState.loading;

  String selectedCity = Restaurants.defaultCity;
  dynamic selectedRating = Restaurants.defaultRating;

  TextEditingController searchController = TextEditingController();

  void readJson() async {
    try {
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/data/local_restaurant.json');
      final data = Restaurants.fromRawJson(response);
      setState(() {
        restaurants = data;
        loadState = LoadState.success;
      });
    } catch (e) {
      setState(() {
        loadState = LoadState.error;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            const RestyAppBar(),
            loadState == LoadState.success
                ? RestySearchBar(
                    onChanged: (value) {
                      setState(() {
                        restaurants.runFilter(
                            value, selectedCity, selectedRating);
                      });
                    },
                    searchController: searchController,
                  )
                : const SliverToBoxAdapter(child: SizedBox()),
            loadState == LoadState.success
                ? _filterBar()
                : const SliverToBoxAdapter(child: SizedBox()),
          ];
        },
        body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: loadState == LoadState.success
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: restaurants.filteredRestaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants.filteredRestaurants[index];
                    return ListViewItem(restaurant: restaurant);
                  },
                )
              : loadState == LoadState.error
                  ? const Center(
                      child: Text("Error loading data"),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
        ),
      ),
    );
  }

  SliverPersistentHeader _filterBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: PersistentHeader(
        height: 40,
        widget: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SelectButton(
                        icon: Icons.location_on,
                        options: restaurants.allCity,
                        selectedOption: selectedCity,
                        onSelected: (city) {
                          setState(() {
                            selectedCity = city;
                            restaurants.runFilter(
                                "", selectedCity, selectedRating);
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      SelectButton(
                        icon: Icons.star_rounded,
                        options: restaurants.allRating,
                        selectedOption: selectedRating,
                        onSelected: (rating) {
                          setState(() {
                            selectedRating = rating;
                            restaurants.runFilter(
                                "", selectedCity, selectedRating);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SmallButton(
                text: "Reset",
                icon: Icons.cancel,
                onTap: () {
                  setState(() {
                    selectedCity = Restaurants.defaultCity;
                    selectedRating = Restaurants.defaultRating;
                    searchController.clear();
                    restaurants.runFilter("", selectedCity, selectedRating);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
