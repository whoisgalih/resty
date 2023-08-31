import 'dart:convert';

class Food {
  String name;

  Food({
    required this.name,
  });

  factory Food.fromRawJson(String str) => Food.fromJson(json.decode(str));

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        name: json["name"],
      );
}
