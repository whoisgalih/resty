import 'package:resty/data/models/customer_review/cutomer_review_model.dart';

class CustomerReviewResult {
  bool error;
  String message;
  List<CustomerReview> customerReviews;

  CustomerReviewResult({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory CustomerReviewResult.fromJson(Map<String, dynamic> json) =>
      CustomerReviewResult(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );
}
