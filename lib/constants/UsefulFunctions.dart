import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/model/user.dart';

class Usefulfunctions {
  static Widget blankSpace({required double width, required double height}) {
    return SizedBox(
      width: width,
      height: height,
    );
  }

  static String getDateFormat(
      {required DateTime dateFormated, required BuildContext context}) {
    int year = dateFormated.year;
    String month = dateFormated.month > 9
        ? dateFormated.month.toString()
        : "0${dateFormated.month}";
    String day = dateFormated.day > 9
        ? dateFormated.day.toString()
        : "0${dateFormated.day}";
    return "$day-$month-$year";
  }

  static String getHourMinuteFormat({required DateTime formatingDate}) {
    String hourDate = formatingDate.hour > 9
        ? formatingDate.hour.toString()
        : "0${formatingDate.hour}";
    String minuteDate = formatingDate.minute > 9
        ? formatingDate.minute.toString()
        : "0${formatingDate.minute}";
    return "$hourDate:$minuteDate";
  }
}
