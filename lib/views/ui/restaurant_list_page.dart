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
import 'package:resty/views/widgets/list_view_item.dart';
import 'package:resty/views/widgets/resty_app_bar.dart';

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
        itemCount: state.result.restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = state.result.restaurants[index];
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
          "Oops, something went wrong",
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
                // loadState == LoadState.success
                //     ? RestySearchBar(
                //         onChanged: (value) {
                //           setState(() {
                //             restaurants.runFilter(
                //                 value, selectedCity, selectedRating);
                //           });
                //         },
                //         searchController: searchController,
                //       )
                //     : const SliverToBoxAdapter(child: SizedBox()),
                // loadState == LoadState.success
                //     ? _filterBar()
                //     : const SliverToBoxAdapter(child: SizedBox()),
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

  // SliverPersistentHeader _filterBar() {
  //   return SliverPersistentHeader(
  //     pinned: true,
  //     delegate: PersistentHeader(
  //       height: 40,
  //       widget: Padding(
  //         padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 scrollDirection: Axis.horizontal,
  //                 child: Row(
  //                   children: [
  //                     SelectButton(
  //                       icon: Icons.location_on,
  //                       options: restaurants.allCity,
  //                       selectedOption: selectedCity,
  //                       onSelected: (city) {
  //                         setState(() {
  //                           selectedCity = city;
  //                           restaurants.runFilter(
  //                               "", selectedCity, selectedRating);
  //                         });
  //                       },
  //                     ),
  //                     const SizedBox(width: 8),
  //                     SelectButton(
  //                       icon: Icons.star_rounded,
  //                       options: restaurants.allRating,
  //                       selectedOption: selectedRating,
  //                       onSelected: (rating) {
  //                         setState(() {
  //                           selectedRating = rating;
  //                           restaurants.runFilter(
  //                               "", selectedCity, selectedRating);
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             SmallButton(
  //               text: "Reset",
  //               icon: Icons.cancel,
  //               onTap: () {
  //                 setState(() {
  //                   selectedCity = Restaurants.defaultCity;
  //                   selectedRating = Restaurants.defaultRating;
  //                   searchController.clear();
  //                   restaurants.runFilter("", selectedCity, selectedRating);
  //                 });
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

// enum LoadState {
//   loading,
//   success,
//   error,
// }

// class RestaurantListPage extends StatefulWidget {
//   static const routeName = '/restaurant_list';

//   const RestaurantListPage({super.key});

//   @override
//   State<RestaurantListPage> createState() => _RestaurantListPageState();
// }

// class _RestaurantListPageState extends State<RestaurantListPage> {
//   late Restaurants restaurants;
//   LoadState loadState = LoadState.loading;

//   String selectedCity = Restaurants.defaultCity;
//   dynamic selectedRating = Restaurants.defaultRating;

//   TextEditingController searchController = TextEditingController();

//   void readJson() async {
//     try {
//       final String response = await DefaultAssetBundle.of(context)
//           .loadString('assets/data/local_restaurant.json');
//       final data = Restaurants.fromRawJson(response);
//       setState(() {
//         restaurants = data;
//         loadState = LoadState.success;
//       });
//     } catch (e) {
//       setState(() {
//         loadState = LoadState.error;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     readJson();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (context, isScrolled) {
//           return [
//             const RestyAppBar(),
//             loadState == LoadState.success
//                 ? RestySearchBar(
//                     onChanged: (value) {
//                       setState(() {
//                         restaurants.runFilter(
//                             value, selectedCity, selectedRating);
//                       });
//                     },
//                     searchController: searchController,
//                   )
//                 : const SliverToBoxAdapter(child: SizedBox()),
//             loadState == LoadState.success
//                 ? _filterBar()
//                 : const SliverToBoxAdapter(child: SizedBox()),
//           ];
//         },
//         body: MediaQuery.removePadding(
//           removeTop: true,
//           context: context,
//           child: loadState == LoadState.success
//               ? restaurants.filteredRestaurants.isNotEmpty
//                   ? ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: restaurants.filteredRestaurants.length,
//                       itemBuilder: (context, index) {
//                         final restaurant =
//                             restaurants.filteredRestaurants[index];
//                         return ListViewItem(restaurant: restaurant);
//                       },
//                     )
//                   : _displayError(
//                       icon: Icons.search_off,
//                       text: RichText(
//                         text: TextSpan(
//                           text: searchController.text,
//                           style:
//                               Theme.of(context).textTheme.titleMedium!.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                           children: [
//                             TextSpan(
//                               text: " not found in restaurants list",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleMedium!
//                                   .copyWith(
//                                     fontWeight: FontWeight.normal,
//                                   ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//               : loadState == LoadState.error
//                   ? _displayError(
//                       icon: Icons.error_outline,
//                       text: Text(
//                         "Oops, something went wrong",
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                     )
//                   : const Center(
//                       child: CircularProgressIndicator(),
//                     ),
//         ),
//       ),
//     );
//   }

//   Column _displayError({
//     required IconData icon,
//     required Widget text,
//   }) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           icon,
//           size: 100,
//           color: primaryColor[300],
//         ),
//         const SizedBox(height: 24),
//         text,
//       ],
//     );
//   }

//   SliverPersistentHeader _filterBar() {
//     return SliverPersistentHeader(
//       pinned: true,
//       delegate: PersistentHeader(
//         height: 40,
//         widget: Padding(
//           padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
//           child: Row(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       SelectButton(
//                         icon: Icons.location_on,
//                         options: restaurants.allCity,
//                         selectedOption: selectedCity,
//                         onSelected: (city) {
//                           setState(() {
//                             selectedCity = city;
//                             restaurants.runFilter(
//                                 "", selectedCity, selectedRating);
//                           });
//                         },
//                       ),
//                       const SizedBox(width: 8),
//                       SelectButton(
//                         icon: Icons.star_rounded,
//                         options: restaurants.allRating,
//                         selectedOption: selectedRating,
//                         onSelected: (rating) {
//                           setState(() {
//                             selectedRating = rating;
//                             restaurants.runFilter(
//                                 "", selectedCity, selectedRating);
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SmallButton(
//                 text: "Reset",
//                 icon: Icons.cancel,
//                 onTap: () {
//                   setState(() {
//                     selectedCity = Restaurants.defaultCity;
//                     selectedRating = Restaurants.defaultRating;
//                     searchController.clear();
//                     restaurants.runFilter("", selectedCity, selectedRating);
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
