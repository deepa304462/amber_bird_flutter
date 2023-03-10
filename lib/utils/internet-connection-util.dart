import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetConnectionUtil {
  InternetConnectionUtil._();

  static bool _isErrorShow = false;
  static bool isNetworkAvailable = false;

  static StreamSubscription<ConnectivityResult> listenConnection(
      BuildContext context) {
    StreamSubscription<ConnectivityResult> subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_isErrorShow && result == ConnectivityResult.none) {
        _showError(context);
      } else {
        if (_isErrorShow) {
          //Navigator.pop(context);
          _isErrorShow = false;
        }
      }
      print(result);
      // Got a new connectivity status!
    });
    return subscription;
  }

  static _showError(BuildContext context) {
    _isErrorShow = true;
    isNetworkAvailable = false;

//    showModalBottomSheet(
//        isDismissible: false,
//        useRootNavigator: true,
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.only(
//              topRight: Radius.circular(10), topLeft: Radius.circular(10)),
//        ),
//        backgroundColor: Colors.white,
//        context: context,
//        builder: (BuildContext bc) {
//          return WillPopScope(
//            onWillPop: () {
//              return Future.value(false);
//            },
//            child: Text('No Internet'),
//          );
//        });
  }
}
