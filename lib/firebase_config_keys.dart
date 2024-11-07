import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseConfigKeys {
  static String get firebaseAndroidApiKey {
    return dotenv.env['ANDROID_API_KEY'] ?? 'no api key';
  }

  static String get fireabaseIosAndroidKey {
    return dotenv.env['IOS_API_KEY'] ?? 'no api key';
  }
}
