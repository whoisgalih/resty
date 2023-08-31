import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resty/provider/restaurants_provider.dart';
import 'package:resty/themes/colors.dart';
import 'package:resty/views/widgets/persistent_header.dart';

class RestySearchBar extends StatelessWidget {
  const RestySearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: PersistentHeader(
        height: 64,
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Material(
              color: Colors.white,
              child: Consumer<RestaurantsProvider>(
                builder: (BuildContext context, RestaurantsProvider state, _) {
                  return TextField(
                    controller: state.searchController,
                    onSubmitted: (_) {
                      state.runFilter();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search restaurant',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: primaryColor[400]),
                      prefixIcon: Icon(
                        Icons.search,
                        color: primaryColor[800],
                      ),
                      suffixIcon: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          state.searchController.clear();
                          state.runFilter();
                        },
                        child: Icon(
                          Icons.clear,
                          color: primaryColor[800],
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
