import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/widget/location-dialog.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GoogleMapLib;
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

class LocationPage extends StatelessWidget {
  LocationController locationController = Get.find();
  late GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return SafeArea(
            child: Stack(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          onMapCreated: locationController.onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: locationController.currentLatLang.value,
                            zoom: 18.0,
                          ),
                          onCameraMove: locationController.updatePosition,
                          markers: {
                            const GoogleMapLib.Marker(
                              markerId: MarkerId('value'),
                            )
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter pincode of your area (Only works in Germany)',
                          style: TextStyles.body,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: AppColors.white)),
                              child: ITextBox(
                                  'Pin Code',
                                  'pinCode',
                                  locationController.pinCode.value != null
                                      ? locationController.pinCode.value
                                          .toString()
                                      : '',
                                  false,
                                  TextInputType.number,
                                  false,
                                  false, (key, value) {
                                locationController.pinCode.value = value;
                              }),
                            ),
                            // ITextBox(
                            //     'Pincode',
                            //     'pinCode',
                            //     locationController.pinCode.value != null
                            //         ? locationController.pinCode.value
                            //             .toString()
                            //         : '',
                            //     false,
                            //     TextInputType.number,
                            //     false,
                            //     false, (key, value) {
                            //   locationController.pinCode.value = value;
                            // }),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onPressed: locationController.pinCode.isEmpty
                                  ? null
                                  : () {
                                      locationController
                                          .findLocalityFromPinCode();
                                    },
                              color: locationController.pinCode.isEmpty
                                  ? AppColors.grey
                                  : AppColors.primeColor,
                              child: Text(
                                'Okay',
                                style: TextStyles.headingFont
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                            locationController.currentLatLang.value.latitude !=
                                    0
                                ? _showAddress(context, locationController)
                                : _accessingLocation(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Image.asset(
                  //   "assets/top-view-map-blue-background.jpg",
                  //   width: 250,
                  // ),
                  Visibility(
                    visible: locationController.addressAvaiable.value,
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: AppColors.primeColor,
                      centerTitle: true,
                      title: ListTile(
                        title: Text(
                          'Save & Continue',
                          style: TextStyles.headingFont
                              .copyWith(color: AppColors.white),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          locationController.saveAddress();
                          // locationController.setLocation();
                          locationController.pinCode.value = locationController
                              .findValueFromAddress('postal_code');
                          locationController.changeAddressData.value =
                              Address.fromMap({
                            'line1':
                                locationController.address['formatted_address'],
                            'houseNo': '',
                            'name': '',
                            'line2': '',
                            'landMark': '',
                            'zipCode': locationController
                                .findValueFromAddress('postal_code'),
                            'city': locationController
                                    .findValueFromAddress('locality') ??
                                locationController.findValueFromAddress(
                                    'administrative_area_level_2'),
                            'country': locationController
                                .findValueFromAddress('country'),
                            'localArea': locationController
                                .findValueFromAddress('sublocality_level_1'),
                            // 'addressType': '',
                            'geoAddress': {
                              'coordinates': [
                                locationController.address['geometry']
                                    ['location']['lat'],
                                locationController.address['geometry']
                                    ['location']['lng']
                              ]
                            },
                            'phoneNumber': '',
                            'directionComment': '',
                          });
                          try {
                            Navigator.pop(context);
                          } catch (e) {
                            Modular.to.pushReplacementNamed('/home/main');
                            // code that handles the exception
                          }
                          // _displayDialog(context, locationController, 'ADD');
                          // locationController.saveAddress();
                        },
                      ),
                    ),
                  )
                ]),
              ],
            ),
          );
        },
      ),
    );
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
          style: TextStyles.headingFont,
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
              style: TextStyles.headingFont.copyWith(color: AppColors.white)),
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
              textStyle: TextStyles.body.copyWith(color: AppColors.white)),
        )
      ],
    );
  }

  Widget _showAddress(
      BuildContext context, LocationController locationController) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Your area according to pincode',
              style:
                  TextStyles.headingFont.copyWith(color: AppColors.primeColor),
            ),
            locationController.findValueFromAddress('sublocality_level_1') !=
                    null
                ? Text(
                    '${locationController.findValueFromAddress('sublocality_level_1')}, ${locationController.findValueFromAddress('locality')}, ${locationController.findValueFromAddress('country')}, ${locationController.findValueFromAddress('postal_code')}' ??
                        '',
                    style: TextStyles.titleFont,
                  )
                : LinearProgressIndicator(
                    color: AppColors.primeColor,
                  ),
          ]),
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

  _displayDialog(BuildContext context, LocationController locationController,
      String type) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 500),
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
        return LocationDialog(type);
        // Material(
        //   type: MaterialType.transparency,
        //   // make sure that the overlay content is not cut off
        //   child: SafeArea(
        //     child: Container(
        //       width: MediaQuery.of(context).size.width,
        //       height: MediaQuery.of(context).size.height,
        //       padding: const EdgeInsets.all(20),
        //       color: Colors.white,
        //       child: Center(
        //         child: Obx(
        //           () => Column(
        //             mainAxisSize: MainAxisSize.min,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: <Widget>[
        //               Text(
        //                 'Edit address',
        //                 style: TextStyles.titleXLargePrimary
        //                     .copyWith(fontWeight: FontWeight.bold),
        //               ),
        //               LocationTextBox(
        //                   'Name',
        //                   'name',
        //                   locationController.changeAddressData.value.name
        //                       .toString(),
        //                   TextInputType.text,
        //                   callback),
        //               const SizedBox(
        //                 height: 10,
        //               ),
        //               LocationTextBox(
        //                   'House No',
        //                   'houseNo',
        //                   locationController.changeAddressData.value.name
        //                       .toString(),
        //                   TextInputType.text,
        //                   callback),
        //               const SizedBox(
        //                 height: 10,
        //               ),
        //               LocationTextBox(
        //                   'Phone',
        //                   'phoneNumber',
        //                   locationController
        //                               .changeAddressData.value.phoneNumber !=
        //                           null
        //                       ? locationController
        //                           .changeAddressData.value.phoneNumber
        //                           .toString()
        //                       : '',
        //                   TextInputType.text,
        //                   callback),
        //               const SizedBox(
        //                 height: 10,
        //               ),
        //               LocationTextBox(
        //                   'Line1',
        //                   'line1',
        //                   locationController.changeAddressData.value.line1
        //                       .toString(),
        //                   TextInputType.text,
        //                   callback),
        //               const SizedBox(
        //                 height: 10,
        //               ),
        //               LocationTextBox(
        //                   'Line2',
        //                   'line2',
        //                   locationController.changeAddressData.value.line2
        //                       .toString(),
        //                   TextInputType.text,
        //                   callback),
        //               const SizedBox(
        //                 height: 10,
        //               ),
        //               LocationTextBox(
        //                   'City',
        //                   'city',
        //                   locationController.changeAddressData.value.city
        //                       .toString(),
        //                   TextInputType.text,
        //                   callback),
        //               const SizedBox(
        //                 height: 10,
        //               ),
        //               LocationTextBox(
        //                   'Country',
        //                   'country',
        //                   locationController.changeAddressData.value.country
        //                       .toString(),
        //                   TextInputType.text,
        //                   callback),
        //               const SizedBox(
        //                 height: 10,
        //               ),
        //               LocationTextBox(
        //                   'LandMark',
        //                   'landMark',
        //                   locationController.changeAddressData.value.landMark
        //                       .toString(),
        //                   TextInputType.text,
        //                   callback),
        //               const SizedBox(
        //                 height: 10,
        //               ),
        //               LocationTextBox(
        //                   'ZipCode',
        //                   'zipCode',
        //                   locationController.changeAddressData.value.zipCode
        //                       .toString(),
        //                   TextInputType.number,
        //                   callback),
        //               const SizedBox(
        //                 height: 10,
        //               ),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.end,
        //                 crossAxisAlignment: CrossAxisAlignment.end,
        //                 children: [
        //                   MaterialButton(
        //                     onPressed: () {
        //                       Navigator.of(context).pop();
        //                     },
        //                     color: AppColors.grey,
        //                     shape: RoundedRectangleBorder(
        //                         borderRadius: BorderRadius.circular(12)),
        //                     child: Text(
        //                       "Close",
        //                       style: TextStyles.titleWhite,
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     width: 20,
        //                   ),
        //                   MaterialButton(
        //                     onPressed: () {
        //                       locationController.addressData.value =
        //                           locationController.changeAddressData.value;
        //                       locationController.setAddressCall();
        //                       Navigator.of(context).pop();
        //                     },
        //                     shape: RoundedRectangleBorder(
        //                         borderRadius: BorderRadius.circular(12)),
        //                     color: AppColors.primeColor,
        //                     child: Text(
        //                       "Save",
        //                       style: TextStyles.titleWhite
        //                           .copyWith(fontWeight: FontWeight.bold),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }

  callback(String p1) {}
}
