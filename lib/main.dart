import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:resty/commons/navigation_helper.dart';

import 'package:resty/data/api/api_service.dart';
import 'package:resty/data/db/database_helper.dart';
import 'package:resty/data/models/restaurants/restaurant_model.dart';
import 'package:resty/provider/add_review_provider.dart';
import 'package:resty/provider/database_provider.dart';
import 'package:resty/provider/restaurant_provider.dart';
import 'package:resty/provider/restaurants_provider.dart';
import 'package:resty/provider/scheduling_provider.dart';
import 'package:resty/themes/colors.dart';
import 'package:resty/utils/background_service.dart';
import 'package:resty/utils/notification_helper.dart';
import 'package:resty/views/ui/add_review_page.dart';
import 'package:resty/views/ui/favorites_page.dart';
import 'package:resty/views/ui/restaurant_list_page.dart';
import 'package:resty/views/ui/restaurant_page.dart';
import 'package:resty/views/ui/settings_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MainApp());
}

final ApiService apiService = ApiService();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantsProvider(
            apiService: apiService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Resty',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: primaryColor,
            accentColor: accentColor,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: primaryColor[50],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: accentColor,
          ),
          appBarTheme: const AppBarTheme(elevation: 0),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: primaryColor[300],
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            elevation: 0,
          ),
        ),
        initialRoute: RestaurantListPage.routeName,
        routes: {
          RestaurantListPage.routeName: (context) => const RestaurantListPage(),
          RestaurantPage.routeName: (context) => ChangeNotifierProvider(
                create: (_) => RestaurantProvider(
                  apiService: apiService,
                  restaurant:
                      ModalRoute.of(context)?.settings.arguments as Restaurant,
                ),
                child: const RestaurantPage(),
              ),
          AddReviewPage.routeName: (context) => ChangeNotifierProvider(
                create: (_) => AddReviewProvider(
                  apiService: apiService,
                  restaurantId:
                      ModalRoute.of(context)?.settings.arguments as String,
                ),
                builder: (context, _) => const AddReviewPage(),
              ),
          FavoritesPage.routeName: (context) => const FavoritesPage(),
          SettingsPage.routeName: (context) => const SettingsPage(),
        },
      ),
    );
  }
}
