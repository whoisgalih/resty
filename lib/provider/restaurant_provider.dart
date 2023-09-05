import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resty/commons/result_state.dart';
import 'package:resty/data/api/api_service.dart';
import 'package:resty/data/models/customer_review/cutomer_review_model.dart';
import 'package:resty/data/models/restaurant_detail/restaurant_detail_result_model.dart';
import 'package:resty/data/models/restaurants/restaurant_model.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  final Restaurant restaurant;

  RestaurantProvider({
    required this.apiService,
    required this.restaurant,
  }) {
    _fetchRestaurant();
    scrollController = ScrollController()..addListener(_isExpandedFunction);
  }

  late ScrollController scrollController;
  bool isExpanded = true;
  bool _isTextExpanded = false;

  bool get isTextExpanded => _isTextExpanded;
  set isTextExpanded(bool value) {
    _isTextExpanded = value;
    notifyListeners();
  }

  void _isExpandedFunction() {
    isExpanded = scrollController.hasClients &&
        scrollController.offset < (300 - kToolbarHeight);
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.removeListener(_isExpandedFunction);
    scrollController.dispose();
    super.dispose();
  }

  // data
  late RestaurantDetailResult _restaurant;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  RestaurantDetailResult get result => _restaurant;
  ResultState get state => _state;

  Future<dynamic> _fetchRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantResult = await apiService.getRestaurant(restaurant.id);

      _state = ResultState.hasData;
      notifyListeners();
      return _restaurant = restaurantResult;
    } on SocketException catch (_) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No Internet Connection';
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Oops! Something went wrong';
    }
  }

  // set reviews
  void setReviews(List<CustomerReview> reviews) {
    _restaurant.restaurant.customerReviews = reviews;
    notifyListeners();
  }
}
