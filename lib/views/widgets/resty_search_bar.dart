import 'package:flutter/material.dart';
import 'package:resty/themes/colors.dart';
import 'package:resty/views/widgets/persistent_header.dart';

class RestySearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onChanged;

  const RestySearchBar(
      {super.key, required this.searchController, required this.onChanged});

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
              child: TextField(
                controller: searchController,
                onChanged: onChanged,
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
                      searchController.clear();
                      onChanged('');
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
