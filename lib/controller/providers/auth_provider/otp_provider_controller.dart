import 'package:flutter/foundation.dart';

class OtpProviderController extends ChangeNotifier{
    String otpMsg = "";
    String phoneNumber = "";
    String verficationId ="";
    void updateVerficationId(String verficationId){
        this.verficationId = verficationId;
    }
    void updateOtpMsg(String otpMsg){
        this.otpMsg = otpMsg;
    }
    void updatePhoneNumber(String phoneNumber){
        this.phoneNumber = phoneNumber;
    }
}
