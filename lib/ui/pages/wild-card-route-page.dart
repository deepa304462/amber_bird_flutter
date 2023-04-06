import 'package:amber_bird/controller/wild-card-page-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WildCardRoutePage extends StatelessWidget {
  final Uri url;
  const WildCardRoutePage(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WildCardPageController controller = Get.put(WildCardPageController(url));
    return Container(
      color: Colors.red,
      child: SizedBox(
        height: 200,
        width: 200,
      ),
    );
  }
}
