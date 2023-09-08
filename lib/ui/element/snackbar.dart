import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum SnackBarType { info, success, warning, error }
class snackBarClass {
  static showToast(context, msg, {SnackBarType? type}) {
    {
      IconData iconData;
      Color iconColor;
      Color snackBarColor;

      // Set the icon and colors based on the snackbar type

      switch (type) {
        case SnackBarType.success:
          iconData = Icons.check_circle;
          iconColor = Colors.green;
          snackBarColor = Colors.black87;
          break;
        case SnackBarType.warning:
          iconData = Icons.warning;
          iconColor = Colors.orange;
          snackBarColor =Colors.black87;
          break;
        case SnackBarType.error:
          iconData = Icons.error;
          iconColor = Colors.red;
          snackBarColor = Colors.black87;
          break;
        default:
          iconData = Icons.info;
          iconColor = Color(0xffF7CE4D); // Default icon color
          snackBarColor = Colors.black87; // Default snackbar background color
          break;
      }
      showTopSnackBar(
          Overlay.of(context),
          padding:EdgeInsets.all(0.0),
          Container(
            height: 100,
            child: CustomSnackBar.info(
              backgroundColor: snackBarColor,
              iconRotationAngle: 1,
              iconPositionLeft: 20,
              iconPositionTop: 10,
              textScaleFactor: 1.2,
              maxLines: 2,
              icon: Icon(
                iconData,
                color: iconColor,
                size: 50,
              ),
              messagePadding: EdgeInsets.only(left: 52,right: 42,top: 10),
              message: msg ?? "Please try again!",
              textStyle: TextStyles.bodyFont
                  .copyWith(color: AppColors.white),
              textAlign: TextAlign.center,
            ),
          ),
        safeAreaValues: SafeAreaValues(top: false, bottom: false, left: false, right: false),
        animationDuration: const Duration(milliseconds: 3000),

      );
    }
  }
}