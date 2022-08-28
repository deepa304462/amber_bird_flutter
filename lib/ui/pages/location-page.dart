import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Column(children: [
              const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/top-view-map-blue-background.jpg'),
                  radius: 180),
              // Image.asset(
              //   "assets/top-view-map-blue-background.jpg",
              //   width: 250,
              // ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Set Your Delivery Location",
                style: TextStyles.titleXLargeBold,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Let us know the location to which you want your orders to be deliered",
                style: TextStyles.bodyFont,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.location_searching,
                  color: Colors.white,
                  size: 30.0,
                ),
                label: Text('Use my current location',
                    style: TextStyles.bodyWhite),
                onPressed: () async {
                  print('Button Pressed');
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
                              SharedData.save('true', 'onboardingDone');
                              Modular.to.navigate('/home/main');
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
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primeColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: TextStyles.bodyWhite),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 30.0,
                ),
                label: Text(
                  'Select Location from map',
                  style: TextStyles.bodyWhite,
                ),
                onPressed: () async {
                  print('Button Pressed');
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
                              Modular.to.navigate('/search-location');
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
                  } else {
                    Modular.to.navigate('/search-location');
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primeColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: TextStyles.bodyWhite),
              ),
            ]),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 35, 25, 0),
              child: TextButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    textStyle: TextStyles.bodyWhite),
                onPressed: () {
                  SharedData.save('true', 'onboardingDone');
                  Modular.to.navigate('/home/main');
                },
                child: Text(
                  "Skip for now",
                  style: TextStyles.bodyFont,
                ),
                // color: Colors.white.withOpacity(0.01),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
