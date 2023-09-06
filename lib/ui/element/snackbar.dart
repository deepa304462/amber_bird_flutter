import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum SnackBarType { info, success, warning, error }
class snackBarClass {
  static showToast(context, msg, {SnackBarType type = SnackBarType.info}) {
    {
      IconData iconData;
      Color iconColor;
      Color snackBarColor;

      // Set the icon and colors based on the snackbar type
      switch (type) {
        case SnackBarType.success:
          iconData = Icons.check_circle;
          iconColor = Colors.green;
          snackBarColor = Colors.green;
          break;
        case SnackBarType.warning:
          iconData = Icons.warning;
          iconColor = Colors.orange;
          snackBarColor = Colors.orange;
          break;
        case SnackBarType.error:
          iconData = Icons.error;
          iconColor = Colors.red;
          snackBarColor = Colors.red;
          break;
        default:
          iconData = Icons.info;
          iconColor = Color(0xffF7CE4D); // Default icon color
          snackBarColor = Colors.black26; // Default snackbar background color
          break;
      }
      showTopSnackBar(
          Overlay.of(context),
          Container(
            width: double.infinity,
            child: Card(
              // color: Colors.black26,
              color: snackBarColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),

              ),
              child: Container(
                padding: EdgeInsets.zero,
                height: 100,
                child: CustomSnackBar.info(
                  backgroundColor: Colors.black26,
                  iconRotationAngle: 1,
                  iconPositionTop: 10,
                  iconPositionLeft: 20,
                  textScaleFactor: 1.2,
                  maxLines: 2,
                  icon: Icon(
                    iconData,
                    color: iconColor,
                    size: 50,
                  ),
                  messagePadding: EdgeInsets.only(top: 22,left :22),
                  message: msg ?? "Please try again!",
                  textStyle: TextStyles.bodyFont
                      .copyWith(color: AppColors.white),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          snackBarPosition: SnackBarPosition.top,
          animationDuration: const Duration(milliseconds: 3000),
          safeAreaValues: SafeAreaValues()
      );
    }
  }
}