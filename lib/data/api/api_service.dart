import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:resty/data/models/restaurant_detail/restaurant_detail_result_model.dart';
import 'package:resty/data/models/restaurants/restaurants_result_model.dart';
import 'package:resty/data/models/restaurants_serach/restaurants_serach_result.dart';

class ApiService {
  static const String baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantsResult> getRestaurants() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl//....list"));
      if (response.statusCode == 200) {
        return RestaurantsResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load restaurants');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }

  Future<RestaurantDetailResult> getRestaurant(String id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/detail/$id"));
      if (response.statusCode == 200) {
        return RestaurantDetailResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load restaurant detail');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }

  Future<RestaurantsSerachResult> searchRestaurants(String query) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/search?q=$query"));
      if (response.statusCode == 200) {
        return RestaurantsSerachResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load restaurants');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }
}
