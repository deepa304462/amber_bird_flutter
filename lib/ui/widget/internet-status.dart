import 'package:amber_bird/utils/ui-style.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/internet-connection-util.dart';

class InternetStatus extends StatelessWidget {
  const InternetStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InternetConnectionUtil.listenConnection(context).onData(
      (data) {
        if (data != ConnectivityResult.none) Navigator.pop(context);
      },
    );
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/no-internet.json',
              width: MediaQuery.of(context).size.width * .5,
              fit: BoxFit.contain),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'No internet connectivity',
              style: TextStyles.bodyFontBold,
            ),
          )
        ],
      ),
    );
  }
}
