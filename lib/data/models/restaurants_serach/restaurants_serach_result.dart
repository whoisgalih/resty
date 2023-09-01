import 'package:resty/data/models/restaurants/restaurant_model.dart';

class RestaurantsSerachResult {
  bool error;
  int founded;
  List<Restaurant> restaurants;

  RestaurantsSerachResult({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory RestaurantsSerachResult.fromJson(Map<String, dynamic> json) =>
      RestaurantsSerachResult(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );
}
