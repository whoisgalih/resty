import 'dart:convert';

import 'package:resty/models/restaurant_model.dart';

class Restaurants {
  // constants
  static const String defaultCity = "All city";
  static const String defaultRating = "All rating";

  // Properties
  List<Restaurant> restaurants;
  late List<Restaurant> filteredRestaurants;

  // Constructor
  Restaurants({
    this.restaurants = const [],
  }) {
    filteredRestaurants = restaurants;
  }

  // Factory method to create a Dart object from a JSON string
  factory Restaurants.fromRawJson(String str) =>
      Restaurants.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };

  // Generator
  List<String> get allCity {
    List<String> cities = [];
    for (var element in restaurants) {
      if (!cities.contains(element.city)) {
        cities.add(element.city);
      }
    }

    cities.sort();
    cities.insert(0, defaultCity);

    return cities;
  }

  List<dynamic> get allRating {
    List<dynamic> ratings = [defaultRating];
    for (int i = 1; i <= 5; i++) {
      ratings.add(i);
    }

    return ratings;
  }

  // Filter process for search, city, and rating
  void runFilter(String search, String city, dynamic rating) {
    filteredRestaurants = restaurants;

    if (city != defaultCity) {
      getRestaurantByCity(city);
    }

    if (search != "") {
      getRestaurantBySearch(search);
    }

    if (rating != defaultRating) {
      getRestaurantByRating(rating);
    }
  }

  // Filter
  void getRestaurantByCity(String city) {
    List<Restaurant> restaurantsByCity = [];
    for (var element in filteredRestaurants) {
      if (element.city == city) {
        restaurantsByCity.add(element);
      }
    }
    filteredRestaurants = restaurantsByCity;
  }

  void getRestaurantBySearch(String search) {
    List<Restaurant> restaurantsBySearch = [];
    for (var element in filteredRestaurants) {
      if (element.name.toLowerCase().contains(search.toLowerCase())) {
        restaurantsBySearch.add(element);
      }
    }
    filteredRestaurants = restaurantsBySearch;
  }

  void getRestaurantByRating(int rating) {
    List<Restaurant> restaurantsByRating = [];
    for (var element in filteredRestaurants) {
      if (element.rating >= rating && element.rating < rating + 1) {
        restaurantsByRating.add(element);
      }
    }
    filteredRestaurants = restaurantsByRating;
  }
}
