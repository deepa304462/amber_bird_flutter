import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class locationWidget extends StatelessWidget {
  final CartController cartController = Get.find();
  final Controller stateController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        GetX<LocationController>(
          builder: (location) {
            return InkWell(
              onTap: () {
                Modular.to.pushNamed('/location');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.location_pin,
                    color: AppColors.black,
                  ),
                  FitText(
                    location.addressData.value.zipCode ?? '',
                    style: TextStyles.body,
                  ),
                  // Text(location.addressData.value.zipCode ?? '',
                  //     style: TextStyles.body)
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  checkLocation(BuildContext context) async {
    PermissionStatus check =
        await Get.find<LocationController>().checkPermission();
    if (check == PermissionStatus.denied) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Use Location?"),
          content: const Text(
              "If you enable Location Services , we can show you nearby Warehouses, and delivery services whle using the app"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.find<LocationController>().locationReqest();
                Navigator.of(ctx).pop();
              },
              child: Container(
                color: Colors.green,
                padding: const EdgeInsets.all(14),
                child: Text("Enable", style: TextStyles.titleWhite),
              ),
            ),
          ],
        ),
      );
      // Get.find<LocationController>().locationReqest();
    }
  }
}
