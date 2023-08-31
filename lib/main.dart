import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resty/data/api/api_service.dart';
import 'package:resty/data/models/restaurants/restaurant_model.dart';
import 'package:resty/provider/restaurant_detail_provider.dart';
import 'package:resty/provider/restaurants_provider.dart';
import 'package:resty/themes/colors.dart';
import 'package:resty/views/ui/restaurant_list_page.dart';
import 'package:resty/views/ui/restaurant_page.dart';

void main() {
  runApp(const MainApp());
}

final ApiService apiService = ApiService();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resty',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primaryColor,
          accentColor: accentColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: primaryColor[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: accentColor,
        ),
      ),
      initialRoute: RestaurantListPage.routeName,
      routes: {
        RestaurantListPage.routeName: (context) => ChangeNotifierProvider(
              create: (_) => RestaurantsProvider(
                apiService: apiService,
              ),
              child: const RestaurantListPage(),
            ),
        RestaurantPage.routeName: (context) => ChangeNotifierProvider(
              create: (_) => RestaurantProvider(
                apiService: apiService,
                restaurant:
                    ModalRoute.of(context)?.settings.arguments as Restaurant,
              ),
              child: const RestaurantPage(),
            ),
      },
    );
  }
}
