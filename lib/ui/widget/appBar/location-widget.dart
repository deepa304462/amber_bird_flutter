import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class locationWidget extends StatelessWidget {
  final CartController cartController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.lightGrey),
            child: Row(children: [
              IconButton(
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                onPressed: () async {
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
                              child:
                                  Text("Enable", style: TextStyles.titleWhite),
                            ),
                          ),
                        ],
                      ),
                    );
                    // Get.find<LocationController>().locationReqest();
                  }
                },
                icon: const Icon(Icons.location_pin, color: Colors.black),
              ),
              GetX<LocationController>(
                  // init: myController,
                  builder: (location) {
                return Text(location.address.toString().length > 20
                    ? location.address.toString().substring(0, 20)
                    : 'Location');
              })
            ]),
          ),
          Obx(() {
            return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.lightGrey),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Text(
                        cartController!.cartProducts!.length.toString() ?? '0'),
                    IconButton(
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Modular.to.navigate('/home/cart');
                      },
                      icon: const Icon(Icons.shopping_basket,
                          color: Colors.black),
                    ),
                  ],
                ));
          }),
        ],
      ),
    );
  }
}
