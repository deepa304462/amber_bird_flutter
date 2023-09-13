import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum SnackBarType { info, success, warning, error }
class snackBarClass {
  static showToast(context, msg, {SnackBarType? type}) {
    final Map<SnackBarType, IconData> iconDataMap = {
      SnackBarType.info: Icons.info,
      SnackBarType.success: Icons.check_circle,
      SnackBarType.warning: Icons.warning,
      SnackBarType.error: Icons.error,
    };

    final Map<SnackBarType, Color> iconColorMap = {
      SnackBarType.info: Color(0xffF7CE4D), // Default icon color
      SnackBarType.success: Colors.green,
      SnackBarType.warning: Colors.orange,
      SnackBarType.error: Colors.red,
    };

    final Map<SnackBarType, Color> snackBarColorMap = {
      SnackBarType.info: Colors.black87, // Default snackbar background color
      SnackBarType.success: Colors.black87,
      SnackBarType.warning: Colors.black87,
      SnackBarType.error: Colors.black87,
    };

    final IconData? iconData = iconDataMap[type ?? SnackBarType.info];
    final Color? iconColor = iconColorMap[type ?? SnackBarType.info];
    final Color? snackBarColor = snackBarColorMap[type ?? SnackBarType.info];

    showTopSnackBar(
          Overlay.of(context),
          padding:EdgeInsets.all(0.0),
          Container(
            height: 100,
            child: CustomSnackBar.info(
              backgroundColor: snackBarColor!,
              iconRotationAngle: 1,
              iconPositionLeft: 20,
              iconPositionTop: 10,
              textScaleFactor: 0.9,
              maxLines: 2,

              icon: Icon(
                iconData,
                color: iconColor,
                size: 50,
              ),
              messagePadding: EdgeInsets.only(left: 34,right: 24,top: 10),
              // message: msg  ?? "Please try again!",
              message:msg ?? "Please try again!",
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