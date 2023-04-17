import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/widget/loading-with-logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_modular/flutter_modular.dart' as routerOut;

class LoaderPage extends StatelessWidget {
  final Controller myController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        IgnorePointer(
            ignoring: myController.showLoader.value,
            child: const routerOut.RouterOutlet()),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => myController.showLoader.value
                  ? const LoadingWithLogo()
                  : const SizedBox(),
            ),
          ),
        )
      ],
    ));
  }
}
