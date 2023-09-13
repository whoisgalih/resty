import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resty/commons/navigation_helper.dart';
import 'package:resty/commons/result_state.dart';
import 'package:resty/provider/database_provider.dart';
import 'package:resty/views/ui/restaurant_page.dart';
import 'package:resty/views/widgets/list_view_item.dart';

class FavoritesPage extends StatelessWidget {
  static const routeName = '/favorites';

  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite")),
      body: Consumer<DatabaseProvider>(
        builder: (BuildContext context, DatabaseProvider provider, _) {
          if (provider.state == ResultState.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final restaurant = provider.favorites[index];
                return ListViewItem(
                  restaurant: restaurant,
                  onTap: () {
                    Navigation.intentWithData(
                      RestaurantPage.routeName,
                      restaurant,
                    );
                  },
                );
              },
            );
          }
          return const Center(
            child: Text("You don't have any favorite restaurant yet"),
          );
        },
      ),
    );
  }
}
