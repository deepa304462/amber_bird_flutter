import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class snackBarClass {
  static showToast(context, msg) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     // action: SnackBarAction(
    //     //   label: 'Action',
    //     //   onPressed: () {
    //     //     // Code to execute.
    //     //   },
    //     // ),
    //     content: Padding(
    //       padding: const EdgeInsets.all(10),
    //       child: Text(
    //         msg ?? "Please try again!",
    //         style: TextStyles.titleFont
    //             .copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
    //       ),
    //     ),
    //     // margin: EdgeInsets.only(
    //     //     bottom: MediaQuery.of(context).size.height - 150,
    //     //     right: 20,
    //     //     left: 20),
    //     duration: const Duration(milliseconds: 3000),
    //     padding: const EdgeInsets.all(8),
    //     behavior: SnackBarBehavior.floating,
    //     backgroundColor: AppColors.primeColor,
    //     shape: RoundedRectangleBorder(
    //         borderRadius: const BorderRadius.only(
    //             topLeft: Radius.circular(12), topRight: Radius.circular(12)),
    //         side: BorderSide(
    //           color: AppColors.white,
    //           width: 1,
    //         )),
    //   ),
    // );\
    showTopSnackBar(
      Overlay.of(context),
      Card(
            color: Colors.black26,
            shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),

            ),
        child: Container(
          padding: EdgeInsets.zero,
          height: 100,
          child: CustomSnackBar.info(
            backgroundColor:Colors.black26,
            iconRotationAngle: 10,
            iconPositionTop: 10,
            iconPositionLeft: 20,
            icon: Icon(Icons.check_circle_rounded,color: Colors.green,size: 34,),
            messagePadding: EdgeInsets.only(top: 22),
            message:msg ?? "Please try again!",
                    textStyle: TextStyles.headingFont2
                        .copyWith(color: AppColors.white),
                  ),
        ),
        ),
      snackBarPosition: SnackBarPosition.top,
      animationDuration: const Duration(milliseconds: 3000),
      safeAreaValues: SafeAreaValues(
       top :false,
      )
    );
  }
}
