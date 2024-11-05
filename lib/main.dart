import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/otp_provider_controller.dart';
import 'package:village_project/view/auth_screen/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        //home:const SplashScreen(),
        home:const AuthScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
