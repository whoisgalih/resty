import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resty/provider/restaurants_provider.dart';
import 'package:resty/views/widgets/persistent_header.dart';
import 'package:resty/views/widgets/select_button.dart';
import 'package:resty/views/widgets/small_button.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  child: Consumer<RestaurantsProvider>(builder:
                      (BuildContext context, RestaurantsProvider state, _) {
                    return Row(
                      children: [
                        SelectButton(
                          icon: Icons.location_on,
                          options: state.allCity,
                          selectedOption: state.selectedCity,
                          onSelected: (city) {
                            state.selectedCity = city;
                            state.runFilter();
                          },
                        ),
                        const SizedBox(width: 8),
                        SelectButton(
                          icon: Icons.star_rounded,
                          options: state.allRating,
                          selectedOption: state.selectedRating,
                          onSelected: (rating) {
                            state.selectedRating = rating;
                            state.runFilter();
                          },
                        ),
                      ],
                    );
                  }),
                ),
              ),
              SmallButton(
                text: "Reset",
                icon: Icons.cancel,
                onTap: () {
                  Provider.of<RestaurantsProvider>(context, listen: false)
                      .resetFilter();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
