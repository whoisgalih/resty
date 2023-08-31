import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:resty/data/models/restaurant_list.dart';

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
}
