import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resty/data/models/customer_review/cutomer_review_body_model.dart';
import 'package:resty/data/models/customer_review/cutomer_review_result_model.dart';
import 'package:resty/data/models/restaurant_detail/restaurant_detail_result_model.dart';
import 'package:resty/data/models/restaurants/restaurants_result_model.dart';
import 'package:resty/data/models/restaurants_serach/restaurants_serach_result.dart';

class ApiService {
  final http.Client client;

  ApiService({
    required this.client,
  });

  static const String baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantsResult> getRestaurants() async {
    final response = await client.get(Uri.parse("$baseUrl/list"));
    if (response.statusCode == 200) {
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<RestaurantDetailResult> getRestaurant(String id) async {
    final response = await client.get(Uri.parse("$baseUrl/detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantDetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantsSerachResult> searchRestaurants(String query) async {
    final response = await client.get(Uri.parse("$baseUrl/search?q=$query"));
    if (response.statusCode == 200) {
      return RestaurantsSerachResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<CustomerReviewResult> postReview(CustomerReviewBody body) async {
    final response = await client.post(
      Uri.parse("$baseUrl/review"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body.toJson()),
    );
    if (response.statusCode == 201) {
      return CustomerReviewResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post review');
    }
  }
}
