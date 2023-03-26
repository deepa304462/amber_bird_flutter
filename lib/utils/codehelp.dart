import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;

import 'package:share_plus/share_plus.dart';

class CodeHelp {
  CodeHelp._();
  static String euro = '€';

  static formatUnit(String? unit) {
    if (unit == 'KILO_GRAM') {
      return "Kg";
    } else if (unit == 'GRAM') {
      return "Gm";
    } else if (unit == 'MILI_LITRE') {
      return "Ml";
    } else if (unit == 'L') {
      return "Lt";
    }
    return unit;
  }

  static shareWithOther(String dataToString, String subject) {
    Share.share(dataToString, subject: subject);
  }

  static toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primeColor,
        textColor: AppColors.white,
        fontSize: 16.0);
  }

  static titleCase(String text) {
    if (text != null && text.length > 0)
      return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
    else
      return text;
  }

  randomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }
}

/* ICU Name                   Skeleton
--------                   --------
DAY                          d
ABBR_WEEKDAY                 E
WEEKDAY                      EEEE
ABBR_STANDALONE_MONTH        LLL
STANDALONE_MONTH             LLLL
NUM_MONTH                    M
NUM_MONTH_DAY                Md
NUM_MONTH_WEEKDAY_DAY        MEd
ABBR_MONTH                   MMM
ABBR_MONTH_DAY               MMMd
ABBR_MONTH_WEEKDAY_DAY       MMMEd
MONTH                        MMMM
MONTH_DAY                    MMMMd
MONTH_WEEKDAY_DAY            MMMMEEEEd
ABBR_QUARTER                 QQQ
QUARTER                      QQQQ
YEAR                         y
YEAR_NUM_MONTH               yM
YEAR_NUM_MONTH_DAY           yMd
YEAR_NUM_MONTH_WEEKDAY_DAY   yMEd
YEAR_ABBR_MONTH              yMMM
YEAR_ABBR_MONTH_DAY          yMMMd
YEAR_ABBR_MONTH_WEEKDAY_DAY  yMMMEd
YEAR_MONTH                   yMMMM
YEAR_MONTH_DAY               yMMMMd
YEAR_MONTH_WEEKDAY_DAY       yMMMMEEEEd
YEAR_ABBR_QUARTER            yQQQ
YEAR_QUARTER                 yQQQQ
HOUR24                       H
HOUR24_MINUTE                Hm
HOUR24_MINUTE_SECOND         Hms
HOUR                         j
HOUR_MINUTE                  jm
HOUR_MINUTE_SECOND           jms
HOUR_MINUTE_GENERIC_TZ       jmv
HOUR_MINUTE_TZ               jmz
HOUR_GENERIC_TZ              jv
HOUR_TZ                      jz
MINUTE                       m
MINUTE_SECOND                ms
SECOND                       s
ISO                          yyyy-MM-ddTHH:mm:ss.mmmuuu
 */
