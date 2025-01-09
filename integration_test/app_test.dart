import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/providers/auth_provider/joined_user_provider.dart';
import 'package:village_project/controller/providers/auth_provider/otp_provider_controller.dart';
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
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    await Firebase.initializeApp();
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
