import 'package:dio/dio.dart';

class HttpServices {
  final Dio dio = Dio();
  final String apiUrl = "http://192.168.100.115:3000/rtcToken";
  Future<String?> getToken() async {
    try {
      var data = await dio.get(apiUrl);
      if (data.statusCode == 200) {
        return data.data["token"].toString();
      }
      print("token is null");
      return null;
    } on DioException catch (e) {
      print("Error: ${e.toString()}");
    }
    return null;
  }
}
