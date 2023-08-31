import 'package:flutter/widgets.dart';
import 'package:resty/commons/result_state.dart';
import 'package:resty/data/api/api_service.dart';
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
  }

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
      if (restaurantResult.restaurant.id.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurant = restaurantResult;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
