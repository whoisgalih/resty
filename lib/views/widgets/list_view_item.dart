import 'package:flutter/material.dart';
import 'package:resty/data/api/api_service.dart';
import 'package:resty/data/models/restaurant_model.dart';
import 'package:resty/themes/colors.dart';
import 'package:resty/views/ui/restaurant_page.dart';

class ListViewItem extends StatelessWidget {
  const ListViewItem({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.pushNamed(
        //   context,
        //   RestaurantPage.routeName,
        //   arguments: restaurant,
        // );
      },
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
                    "${ApiService.baseUrl}/images/small/${restaurant.pictureId}",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
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
            ],
          ),
        ),
      ),
    );
  }
}
