import 'package:flutter_test/flutter_test.dart';
import 'package:village_project/main.dart';
import 'package:village_project/view/user/splash_screen.dart';
import 'package:village_project/view/user/user_bottom_nav_bar.dart';

void main() {
  testWidgets('Village app', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    //expect(find.byType(SplashScreen), findsOneWidget);
    //expect(find.text("ايغمان"), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    //await tester.tap(find.byIcon(Icons.add));
    //final button = find.byIcon(Icons.home);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    //expect(find.byType(UserBottomNavBar), findsOneWidget);
    await tester.pump();

    // Verify that our counter has incremented.
    //expect(find.text('1'), findsOneWidget);
    //expect(find.text('home'), findsAny);
  });
}
