import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../../../helpers/controller-generator.dart';

class LocationWidget extends StatefulWidget {
  LocationWidget({Key? key}) : super(key: key);

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  final Controller stateController = Get.find();
  final LocationController locationController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          onTap: () {
            Modular.to.pushNamed('/location').then((value) {
              setState(() {});
            });
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
              Obx(() => FitText(
                    locationController.pinCode.value ?? '0',
                    style: TextStyles.body,
                  )),
              // Text(location.addressData.value.zipCode ?? '',
              //     style: TextStyles.body)
            ],
          ),
        )
      ],
    );
  }
}
