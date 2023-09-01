import 'package:flutter/material.dart';
import 'package:resty/commons/result_state.dart';
import 'package:resty/data/api/api_service.dart';
import 'package:resty/data/models/customer_review/cutomer_review_body_model.dart';
import 'package:resty/data/models/customer_review/cutomer_review_result_model.dart';
import 'package:resty/data/models/customer_review/cutomer_review_model.dart';

class AddReviewProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  AddReviewProvider({
    required this.apiService,
    required this.restaurantId,
  });

  // state
  late List<CustomerReview> _reviews;
  ResultState _state = ResultState.noData;
  String _message = '';

  List<CustomerReview> get reviews => _reviews;
  ResultState get state => _state;
  String get message => _message;

  // form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // text editing controller
  TextEditingController nameController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

  // validation
  String? nameValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    } else if (value.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  String? reviewValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Review is required';
    }
    return null;
  }

  // method
  Future<dynamic> addReview() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final CustomerReviewResult result = await apiService.postReview(
        CustomerReviewBody(
          id: restaurantId,
          name: nameController.text,
          review: reviewController.text,
        ),
      );
      if (result.customerReviews.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _reviews = result.customerReviews;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      // return _message = 'Oops! Something went wrong';
      return _message = e.toString();
    }
  }
}
