import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/ui/element/location-text-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      padding: const EdgeInsets.all(20.0),
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
            style: TextStyles.titleXLargePrimary.copyWith(fontSize: 20),
          ),
          locationController.addressData.value.line1 != null
              ? ListTile(
                  visualDensity: VisualDensity.comfortable,
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      locationController.addressData.value.line1 ?? '',
                      style: TextStyles.bodyFontBold,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      locationController.changeAddressData.value =
                          locationController.addressData.value;
                      _displayDialog(context, locationController);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: AppColors.primeColor,
                      size: 20,
                    ),
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

  _displayDialog(BuildContext context, LocationController locationController) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 500),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          // make sure that the overlay content is not cut off
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Center(
                child: Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Edit address',
                        style: TextStyles.titleXLargePrimary
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      LocationTextBox(
                          'Name',
                          'name',
                          locationController.changeAddressData.value.name
                              .toString(),
                          TextInputType.text,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationTextBox(
                          'Line1',
                          'line1',
                          locationController.changeAddressData.value.line1
                              .toString(),
                          TextInputType.text,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationTextBox(
                          'Line2',
                          'line2',
                          locationController.changeAddressData.value.line2
                              .toString(),
                          TextInputType.text,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationTextBox(
                          'City',
                          'city',
                          locationController.changeAddressData.value.city
                              .toString(),
                          TextInputType.text,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationTextBox(
                          'Country',
                          'country',
                          locationController.changeAddressData.value.country
                              .toString(),
                          TextInputType.text,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationTextBox(
                          'LandMark',
                          'landMark',
                          locationController.changeAddressData.value.landMark
                              .toString(),
                          TextInputType.text,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationTextBox(
                          'ZipCode',
                          'zipCode',
                          locationController.changeAddressData.value.zipCode
                              .toString(),
                          TextInputType.number,
                          callback),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: AppColors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              "Close",
                              style: TextStyles.titleWhite,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          MaterialButton(
                            onPressed: () {
                              locationController.addressData.value =
                                  locationController.changeAddressData.value;
                              locationController.setAddressCall();
                              Navigator.of(context).pop();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: AppColors.primeColor,
                            child: Text(
                              "Save",
                              style: TextStyles.titleWhite
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  callback(String p1) {}
}
