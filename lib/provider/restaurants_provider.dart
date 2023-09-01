import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resty/commons/result_state.dart';
import 'package:resty/data/api/api_service.dart';
import 'package:resty/data/models/restaurants/restaurant_model.dart';
import 'package:resty/data/models/restaurants/restaurants_result_model.dart';
import 'package:resty/data/models/restaurants_serach/restaurants_serach_result.dart';

class RestaurantsProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantsProvider({
    required this.apiService,
  }) {
    _getAllRestaurants();
    _getAllRating();
  }

  // restaurants
  late List<Restaurant> _restaurants;
  late ResultState _state;
  String _message = '';

  List<Restaurant> get restaurants => _restaurants;
  String get message => _message;
  ResultState get state => _state;

  // default filter
  static const String defaultCity = 'All City';
  static const String defaultRating = 'All Rating';

  // search
  TextEditingController searchController = TextEditingController();

  bool _isSearching = false;

  bool get isSearching => _isSearching;

  // filter
  late List<String> _allCity;
  String selectedCity = defaultCity;

  late List<dynamic> _allRating;
  dynamic selectedRating = defaultRating;

  List<String> get allCity => _allCity;
  List<dynamic> get allRating => _allRating;

  List<String> _getAllCity() {
    List<String> cities = [];
    for (var restaurant in _restaurants) {
      if (!cities.contains(restaurant.city)) {
        cities.add(restaurant.city);
      }
    }
    cities.sort();
    cities.insert(0, defaultCity);
    notifyListeners();
    return _allCity = cities;
  }

  void _getAllRating() {
    List<dynamic> ratings = [defaultRating];
    for (int i = 0; i <= 5; i++) {
      ratings.add(i);
    }
    _allRating = ratings;
  }

  Future<dynamic> _getAllRestaurants() async {
    try {
      _isSearching = false;
      _state = ResultState.loading;
      notifyListeners();
      final RestaurantsResult restaurants = await apiService.getRestaurants();
      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No data';
      } else {
        _state = ResultState.hasData;
        _restaurants = restaurants.restaurants;
        notifyListeners();
        _getAllCity();
        return _restaurants;
      }
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

  Future<dynamic> _searchRestaurants(String query) async {
    try {
      _isSearching = true;
      _state = ResultState.loading;
      notifyListeners();
      final RestaurantsSerachResult restaurants =
          await apiService.searchRestaurants(query);
      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = query;
      } else {
        _state = ResultState.hasData;
        _restaurants = restaurants.restaurants;
        notifyListeners();
        _getAllCity();
        return _restaurants;
      }
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

  dynamic runFilter() async {
    await _searchRestaurants(searchController.text);

    if (_state == ResultState.hasData) {
      _state = ResultState.loading;
      notifyListeners();

      // filter city
      if (selectedCity != defaultCity) {
        _restaurants = _restaurants
            .where((restaurant) => restaurant.city == selectedCity)
            .toList();
      }

      // filter rating
      if (selectedRating != defaultRating) {
        _restaurants = _restaurants
            .where((restaurant) =>
                restaurant.rating >= selectedRating &&
                restaurant.rating < selectedRating + 1)
            .toList();
      }

      // return result
      if (_restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = searchController.text;
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurants;
      }
    }
  }

  void resetFilter() {
    if (selectedCity != defaultCity || selectedRating != defaultRating) {
      selectedCity = defaultCity;
      selectedRating = defaultRating;
      runFilter();
    }
  }
}
