import 'package:flutter/foundation.dart';

class OtpProviderController extends ChangeNotifier {
  String otpMsg = "";
  String phoneNumber = "";
  String verficationId = "";
  bool isRegisterOtpType = false;
  void updateVerficationId(String verficationId) {
    this.verficationId = verficationId;
    notifyListeners();
  }

  void updateOtpMsg(String otpMsg) {
    this.otpMsg = otpMsg;
    notifyListeners();
  }

  void updatePhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
    notifyListeners();
  }

  void updateOtpType(bool isRegisterOtpType) {
    this.isRegisterOtpType = isRegisterOtpType;
    notifyListeners();
  }
}
