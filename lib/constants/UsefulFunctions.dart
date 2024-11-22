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
    int month = dateFormated.month;
    String day = dateFormated.day > 9
        ? dateFormated.day.toString()
        : "0${dateFormated.day}";
    return "$day-$month-$year";
  }
}
