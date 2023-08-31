import 'dart:convert';

class Drink {
  String name;

  Drink({
    required this.name,
  });

  factory Drink.fromRawJson(String str) => Drink.fromJson(json.decode(str));

  factory Drink.fromJson(Map<String, dynamic> json) => Drink(
        name: json["name"],
      );
}
