import 'package:flutter_test/flutter_test.dart';
import 'package:resty/data/models/restaurants/restaurant_model.dart';

void main() {
  group('Restaurant Tests', () {
    test('Restaurant.fromJson() converts a JSON map into a Restaurant object',
        () {
      // Arrange
      final Map<String, dynamic> json = {
        "id": "1",
        "name": "Restaurant Name",
        "description": "Restaurant Description",
        "pictureId": "restaurant_picture",
        "city": "Restaurant City",
        "rating": 4.5,
      };

      // Act
      final Restaurant restaurant = Restaurant.fromJson(json);

      // Assert
      expect(restaurant.id, "1");
      expect(restaurant.name, "Restaurant Name");
      expect(restaurant.description, "Restaurant Description");
      expect(restaurant.pictureId, "restaurant_picture");
      expect(restaurant.city, "Restaurant City");
      expect(restaurant.rating, 4.5);
    });

    test('Restaurant.toJson() converts a Restaurant object into a JSON map',
        () {
      // Arrange
      final Restaurant restaurant = Restaurant(
        id: "2",
        name: "Another Restaurant",
        description: "Another Description",
        pictureId: "another_picture",
        city: "Another City",
        rating: 3.8,
      );

      // Act
      final Map<String, dynamic> json = restaurant.toJson();

      // Assert
      expect(json['id'], "2");
      expect(json['name'], "Another Restaurant");
      expect(json['description'], "Another Description");
      expect(json['pictureId'], "another_picture");
      expect(json['city'], "Another City");
      expect(json['rating'], 3.8);
    });
  });
}
