import 'package:flutter_test/flutter_test.dart';
import 'package:resty/data/models/restaurants/restaurants_result_model.dart';

void main() {
  group('RestaurantsResult Tests', () {
    test(
        'RestaurantsResult.fromJson() converts a JSON map into a RestaurantsResult object',
        () {
      // Arrange
      final Map<String, dynamic> json = {
        "error": false,
        "message": "Success",
        "count": 3,
        "restaurants": [
          {
            "id": "1",
            "name": "Restaurant 1",
            "description": "Description 1",
            "pictureId": "picture_1",
            "city": "City 1",
            "rating": 4.2,
          },
          {
            "id": "2",
            "name": "Restaurant 2",
            "description": "Description 2",
            "pictureId": "picture_2",
            "city": "City 2",
            "rating": 3.9,
          },
        ],
      };

      // Act
      final RestaurantsResult result = RestaurantsResult.fromJson(json);

      // Assert
      expect(result.error, false);
      expect(result.message, "Success");
      expect(result.count, 3);
      expect(result.restaurants.length, 2);
      expect(result.restaurants[0].name, "Restaurant 1");
      expect(result.restaurants[1].name, "Restaurant 2");
    });
  });
}
