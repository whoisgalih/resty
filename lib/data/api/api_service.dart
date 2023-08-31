import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resty/data/models/restaurant_detail/restaurant_detail_result_model.dart';
import 'package:resty/data/models/restaurants/restaurants_result_model.dart';
import 'package:resty/data/models/restaurants_serach/restaurants_serach_result.dart';

class ApiService {
  static const String baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantsResult> getRestaurants() async {
    final response = await http.get(Uri.parse("$baseUrl/list"));
    if (response.statusCode == 200) {
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<RestaurantDetailResult> getRestaurant(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantDetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantsSerachResult> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse("$baseUrl/search?q=$query"));
    if (response.statusCode == 200) {
      return RestaurantsSerachResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurants');
    }
  }
}
