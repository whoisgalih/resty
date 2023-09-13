import 'package:flutter/material.dart';
import 'package:resty/commons/navigation_helper.dart';
import 'package:resty/views/ui/favorites_page.dart';
import 'package:resty/views/ui/settings_page.dart';

class RestyAppBar extends StatelessWidget {
  const RestyAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      collapsedHeight: 70,
      expandedHeight: 200,
      actions: [
        IconButton(
          onPressed: () {
            Navigation.intentWithData(FavoritesPage.routeName, 0);
          },
          icon: const Icon(Icons.favorite_outline),
        ),
        // settings
        IconButton(
          onPressed: () {
            Navigation.intentWithData(SettingsPage.routeName, 0);
          },
          icon: const Icon(Icons.settings_outlined),
        ),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(20),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Resty',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text("Recommended restaurant for you",
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        background: Image.asset(
          'assets/images/gradient_background.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
