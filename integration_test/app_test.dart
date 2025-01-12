import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/providers/auth_provider/joined_user_provider.dart';
import 'package:village_project/controller/providers/auth_provider/otp_provider_controller.dart';
import 'package:village_project/firebase_options.dart';
import 'package:village_project/view/user/splash_screen.dart';

Widget createdMyApp() => MultiProvider(
        providers: [
          ChangeNotifierProvider<OtpProviderController>(
              create: (ctx) => OtpProviderController()),
          ChangeNotifierProvider<JoinedUserProvider>(
              create: (ctx) => JoinedUserProvider()),
          ChangeNotifierProvider<IghoumaneUserProvider>(
              create: (ctx) => IghoumaneUserProvider()),
        ],
        child: MaterialApp(
          home: SplashScreen(),
        ));
//void main() {
//  // Initialize the test binding
//  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
//  setUpAll(() async {
//    // Load environment variables
//    await dotenv.load(fileName: ".env");
//
//    // Ensure Firebase is initialized only once
//    if (Firebase.apps.isEmpty) {
//      await Firebase.initializeApp(
//        name: 'name',
//        options: DefaultFirebaseOptions.currentPlatform,
//      );
//    }
//  });
//
//  //tearDown(() async {
//  //  // Reset Firebase between tests (if necessary)
//  //  if (Firebase.apps.isNotEmpty) {
//  //    await Firebase.app().delete();
//  //  }
//  //});
//
//  group('Testing initializing app', () {
//    testWidgets('Test AuthScreen visibility', (tester) async {
//      // Build the app widget
//      await tester.pumpWidget(createdMyApp());
//
//      // Wait for the splash screen to finish
//      await tester.pumpAndSettle(const Duration(seconds: 4));
//
//      // Check that the Login screen is displayed
//      expect(find.text('Login'), findsOneWidget);
//
//      // Simulate a tap on the "Login" button
//      await tester.tap(find.text('Login'));
//
//      // Wait for the app to settle
//      await tester.pumpAndSettle(const Duration(seconds: 1));
//
//      // Verify that the "Login" screen is still displayed
//      expect(find.text('Login'), findsOneWidget);
//
//      await tester.pump();
//    });
//  });
//}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          name: 'name',
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  });

  group('Testing intializing app', () {
    testWidgets('Test AuthScreen visibility', (tester) async {
      await tester.pumpWidget(createdMyApp());
      await tester.pumpAndSettle(const Duration(seconds: 4));
      expect(find.text('Login'), findsOneWidget);
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Login'), findsOneWidget);
      //expect(find.text('+212  '), findsOneWidget);
      await tester.pump();
    });
    //testWidgets('', (tester) async {});
  });
}
