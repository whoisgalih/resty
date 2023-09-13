import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resty/data/api/api_service.dart';
import 'package:resty/data/models/restaurants/restaurant_model.dart';
import 'package:resty/provider/database_provider.dart';
import 'package:resty/themes/colors.dart';

class ListViewItem extends StatelessWidget {
  const ListViewItem({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  final Restaurant restaurant;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Hero(
                tag: restaurant.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    "${ApiService.baseUrl}/images/large/${restaurant.pictureId}",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: 100,
                        color: primaryColor[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.name,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: primaryColor[300],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                restaurant.city,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: primaryColor[400],
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: accentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.rating.toString(),
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: accentColor[700],
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Consumer<DatabaseProvider>(
                builder: (BuildContext context, DatabaseProvider provider, _) {
                  return FutureBuilder(
                    future: provider.isFavorite(restaurant.id),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      bool isFavorite = snapshot.data ?? false;
                      if (isFavorite) {
                        return IconButton(
                          onPressed: () {
                            provider.removeFavorite(restaurant.id);
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: accentColor[500],
                          ),
                        );
                      } else {
                        return IconButton(
                          onPressed: () {
                            provider.addFavorite(restaurant);
                          },
                          icon: Icon(
                            Icons.favorite_border,
                            color: primaryColor[300],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
