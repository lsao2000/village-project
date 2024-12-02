import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/providers/auth_provider/joined_user_provider.dart';
import 'package:village_project/controller/providers/auth_provider/otp_provider_controller.dart';
import 'package:village_project/firebase_messaging_api.dart';
import 'package:village_project/view/auth_screen/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:village_project/view/user/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception("not initialize dotenv ${e.toString()}");
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessagingApi().requestNotificationPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OtpProviderController>(
            create: (ctx) => OtpProviderController()),
        ChangeNotifierProvider<JoinedUserProvider>(
            create: (ctx) => JoinedUserProvider()),
        ChangeNotifierProvider<IghoumaneUserProvider>(
            create: (ctx) => IghoumaneUserProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        //home:const AuthScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
