import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:resty/data/api/api_service.dart';
import 'package:resty/data/db/database_helper.dart';
import 'package:resty/provider/database_provider.dart';
import 'package:resty/provider/restaurants_provider.dart';
import 'package:resty/views/ui/restaurant_list_page.dart';
import 'package:resty/views/widgets/list_view_item.dart';

@GenerateNiceMocks([MockSpec<http.Client>(), MockSpec<DatabaseHelper>()])
import 'restaurant_list_page_test.mocks.dart';

void main() {
  group('RestaurantListPage Widget Test', () {
    testWidgets('Should display loading indicator when data is loading',
        (WidgetTester tester) async {
      // Mock the HTTP client
      final mockHttpClient = MockClient();

      // Build our widget under test.
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<RestaurantsProvider>(
            create: (context) => RestaurantsProvider(
                apiService: ApiService(client: mockHttpClient)),
            child: RestaurantListPage(),
          ),
        ),
      );

      // Verify that the CircularProgressIndicator is displayed.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should display error message when data loading fails',
        (WidgetTester tester) async {
      // URI to mock
      final uri = Uri.parse("https://restaurant-api.dicoding.dev/list");

      // Mock the HTTP response to return a loading state.
      final mockHttpClient = MockClient();
      when(mockHttpClient.get(uri)).thenAnswer((_) async => http.Response(
            '{"state": "error", "message": "Something went wrong"}',
            500,
          ));

      // Build our widget under test.
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<RestaurantsProvider>(
            create: (context) => RestaurantsProvider(
                apiService: ApiService(client: mockHttpClient)),
            child: RestaurantListPage(),
          ),
        ),
      );

      // Verify that the CircularProgressIndicator is displayed.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait until the data is loaded
      await tester.pumpAndSettle();

      // Verify that the list of restaurants is displayed.
      expect(find.text("Oops! Something went wrong"), findsOneWidget);
      verify(mockHttpClient.get(uri)).called(1);
    });

    testWidgets('Should display list of restaurants when data is loaded',
        (WidgetTester tester) async {
      // URI to mock
      final uri = Uri.parse("https://restaurant-api.dicoding.dev/list");

      // Mock the HTTP response to return a loading state.
      final mockHttpClient = MockClient();
      when(mockHttpClient.get(uri)).thenAnswer((_) async => http.Response(
            '''{
  "error": false,
  "message": "success",
  "count": 20,
  "restaurants": [
      {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
          "pictureId": "14",
          "city": "Medan",
          "rating": 4.2
      },
      {
          "id": "s1knt6za9kkfw1e867",
          "name": "Kafe Kita",
          "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
          "pictureId": "25",
          "city": "Gorontalo",
          "rating": 4
      }
  ]
}''',
            200,
          ));

      // Api Service mock
      final apiService = ApiService(client: mockHttpClient);

      // Database Helper mock
      final mockDatabaseHelper = MockDatabaseHelper();
      when(mockDatabaseHelper.getFavorites()).thenAnswer((_) async => []);

      // Build our widget under test.
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => RestaurantsProvider(
                apiService: apiService,
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => DatabaseProvider(
                databaseHelper: mockDatabaseHelper,
              ),
            ),
          ],
          child: MaterialApp(
            home: RestaurantListPage(),
          ),
        ),
      );

      // Verify that the CircularProgressIndicator is displayed.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait until the data is loaded
      await tester.pumpAndSettle();

      // Verify that the list of restaurants is displayed.
      expect(find.byType(ListViewItem), findsNWidgets(2));
      verify(mockHttpClient.get(uri)).called(1);
    });
  });
}
