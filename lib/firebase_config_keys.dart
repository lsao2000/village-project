import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseConfigKeys {
  static String get firebaseAndroidApiKey {
    return dotenv.env['ANDROID_API_KEY'] ?? 'no api key';
  }

  static String get fireabaseIosAndroidKey {
    return dotenv.env['IOS_API_KEY'] ?? 'no api key';
  }

  static String get agoraAppId {
    return dotenv.env['APP_ID'] ?? '';
  }

  static String? get firebaseWebApiKey {
    return dotenv.env['WEB_API_KEY'];
  }

  static String? get firebaseMacosApiKey {
    return dotenv.env['MACOS_API_KEY'];
  }

  static String? get firebaseWindowsApiKey {
    return dotenv.env['WINDOWS_API_KEY'];
  }
}
