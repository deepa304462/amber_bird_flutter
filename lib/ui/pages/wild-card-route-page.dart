import 'package:amber_bird/controller/wild-card-page-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WildCardRoutePage extends StatelessWidget {
  final Uri url;
  final dynamic args;
  const WildCardRoutePage(this.url, this.args, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WildCardPageController(url, args));
    return Container(
      color: Colors.red,
      child: SizedBox(
        height: 200,
        width: 200,
      ),
    );
  }
}
