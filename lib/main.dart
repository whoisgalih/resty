import 'package:flutter/material.dart';
import 'package:resty/models/restautrant_model.dart';
import 'package:resty/themes/colors.dart';
import 'package:resty/views/home_page.dart';
import 'package:resty/views/resturant_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resty',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primaryColor,
          primaryColorDark: primaryColor.shade50,
          accentColor: accentColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: primaryColor[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: RestaurantListPage.routeName,
      routes: {
        RestaurantListPage.routeName: (context) => const RestaurantListPage(),
        RestaurantPage.routeName: (context) => RestaurantPage(
              restaurant:
                  ModalRoute.of(context)!.settings.arguments as Restaurant,
            ),
      },
    );
  }
}
