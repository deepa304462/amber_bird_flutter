import 'dart:developer';

import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as Google;
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

class LocationPage extends StatelessWidget {
  LocationController locationController = Get.find();
  late GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      return Stack(
        children: [
          Column(children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: locationController.currentLatLang.value.latitude != 0
                    ? GoogleMap(
                        onMapCreated: locationController.onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: locationController.currentLatLang.value,
                          zoom: 18.0,
                        ),
                        onCameraMove: locationController.updatePosition,
                        markers: Set.of([locationController.currentPin.value]),
                      )
                    : Lottie.network(
                        'https://assets1.lottiefiles.com/packages/lf20_is82b4.json',
                        frameRate: FrameRate(50),
                        repeat: false),
              ),
            ),

            // Image.asset(
            //   "assets/top-view-map-blue-background.jpg",
            //   width: 250,
            // ),
            locationController.currentLatLang.value.latitude != 0
                ? _showAddress(context, locationController)
                : locationController.mapLoad.value
                    ? _accessingLocation(context)
                    : _askLocationWidgetUi(context, locationController),
          ]),
        ],
      );
    }));
  }

  _askLocationWidgetUi(
      BuildContext context, LocationController locationController) {
    return Column(
      children: [
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
              style: TextStyles.titleXLargeWhite),
          onPressed: () async {
            PermissionStatus check = await locationController.checkPermission();
            if (check == PermissionStatus.denied) {
              locationController.initializeLocationAndSave();
            } else {
              locationController.initializeLocationAndSave();
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primeColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              textStyle: TextStyles.bodyWhite),
        )
      ],
    );
  }

  Widget _showAddress(
      BuildContext context, LocationController locationController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Drag map pin to change address',
              style: TextStyles.headingFontGray,
            ),
          ),
          Text(
            'Your address',
            style: TextStyles.titleXLargePrimary,
          ),
          locationController.address.value['formatted_address'] != null
              ? ListTile(
                  title: Text(
                    locationController.address.value['formatted_address'],
                    style: TextStyles.bodyFontBold,
                  ),
                  subtitle: Text(
                    'Edit',
                    style: TextStyles.titleLight,
                  ),
                )
              : LinearProgressIndicator(
                  color: AppColors.primeColor,
                ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.location_searching,
                color: Colors.white,
                size: 30.0,
              ),
              label:
                  Text('Save & Continue', style: TextStyles.titleXLargeWhite),
              onPressed: () async {
                locationController.saveAddress();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: AppColors.primeColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                  textStyle: TextStyles.bodyWhite),
            ),
          )
        ],
      ),
    );
  }

  _accessingLocation(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Lottie.network(
        'https://assets10.lottiefiles.com/packages/lf20_Y6YtJv.json',
      ),
    );
  }
}
