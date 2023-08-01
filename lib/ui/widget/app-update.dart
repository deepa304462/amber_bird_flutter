import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';

class AppUpdate extends StatelessWidget {
  AppUpdate({Key? key}) : super(key: key);
  final InAppReview inAppReview = InAppReview.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/app-update.json',
                  width: MediaQuery.of(context).size.width, fit: BoxFit.fill, height: MediaQuery.of(context).size.height * .3),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'New update available, Kindly install update',
                  style: TextStyles.bodyFontBold,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  inAppReview.openStoreListing(appStoreId:"6448874245" );
                },
                color: AppColors.primeColor,
                child: Text(
                  'Install update',
                  style: TextStyles.bodyFontBold.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
              color: AppColors.DarkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
