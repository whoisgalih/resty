import 'package:flutter/material.dart';
import 'package:resty/commons/result_state.dart';
import 'package:resty/data/api/api_service.dart';
import 'package:resty/data/models/restaurant_list.dart';

class RestaurantsProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantsProvider({required this.apiService}) {
    _fetchAllRestaurants();
  }

  late RestaurantsResult _restaurantsResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  RestaurantsResult get result => _restaurantsResult;
  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurants = await apiService.getRestaurants();
      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantsResult = restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
