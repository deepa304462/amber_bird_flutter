import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

class snackBarClass {
  static showToast(context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // action: SnackBarAction(
        //   label: 'Action',
        //   onPressed: () {
        //     // Code to execute.
        //   },
        // ),
        content: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            msg ?? "Please try again!",
            style: TextStyles.title
                .copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
          ),
        ),
        duration: const Duration(milliseconds: 3000),
        padding: const EdgeInsets.all(8),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primeColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppColors.white,
              width: 1,
            )),
      ),
    );
  }
}
