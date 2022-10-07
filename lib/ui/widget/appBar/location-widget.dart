import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.location_pin,
                    color: AppColors.primeColor,
                  ),
                  Text(location.findValueFromAddress('postal_code'),
                      style: TextStyles.body)
                ],
              ),
            );
          },
        ),
        Obx(() {
          return Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              InkWell(
                onTap: () {
                  stateController.navigateToUrl('/home/cart');
                },
                child: Card(
                  color: AppColors.primeColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.shopping_bag_rounded,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                      cartController.cartProducts.value.length.toString() ??
                          '99',
                      style: TextStyles.bodyFontBold),
                )),
              ),
            ],
          );
        }),
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
