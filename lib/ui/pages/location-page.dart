import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/ui/widget/location-dialog.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GoogleMapLib;
import 'package:lottie/lottie.dart';
import 'package:amber_bird/utils/data-cache-service.dart';

class LocationPage extends StatefulWidget {
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
    getCoordinate();

    super.initState();
  }

  getCoordinate() async {
    isLoading.value = true;

    await locationController.getCoordinate();
    isLoading.value = false;
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: locationController.currentLatLang.value, zoom: 17)));
  }

  LocationController locationController = Get.find();
  RxBool isLoading = true.obs;
  TextEditingController _textController = TextEditingController();

  GoogleMapController? mapController;

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
                      child: !isLoading.value
                          ? GoogleMap(
                              onMapCreated: (GoogleMapController controller) {
                                locationController.gmapController?.value =
                                    controller;
                                setState(() {
                                  mapController = controller;
                                });

                                // setState(() {});
                              },
// }locationController.onMapCreated,
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
                            )
                          : Lottie.asset(
                              'assets/maps.json',
                              repeat: true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter POSTCODE to connect with your nearest warehouse',
                          style: TextStyles.bodyFont
                              .copyWith(color: AppColors.primeColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Pincode links you to the nearest warehouse. Now in Germany, Europe up next!',
                            style: TextStyles.bodyFont
                                .copyWith(color: AppColors.black),

                          ),
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
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * .3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextField(
                                        decoration: InputDecoration(
                                            labelText: "Search your Pincode",
                                            hintText: "Type home address",
                                            suffixIcon: InkWell(
                                                onTap: () {
                                                  _textController.clear();
                                                  locationController
                                                      .pincodeSuggestions
                                                      .clear();
                                                },
                                                child:
                                                    const Icon(Icons.clear))),
                                        controller: _textController,
                                        onChanged: (String changedText) {
                                          locationController
                                              .searchPincode(changedText);
                                        },
                                      ),
                                      Expanded(
                                        child: Obx(
                                          () => ListView(
                                            shrinkWrap: true,
                                            children: locationController
                                                .pincodeSuggestions
                                                .map(
                                                  (element) => TextButton(
                                                    onPressed: () {
                                                      locationController
                                                              .pinCode.value =
                                                          element['properties']
                                                              ['postcode'];
                                                      SharedData.save(
                                                          locationController
                                                              .pinCode.value,
                                                          'pinCode');
                                                      locationController
                                                          .updateCustomerAddress(
                                                              element);
                                                      locationController.address
                                                          .value = element;
                                                      locationController
                                                              .currentLatLang
                                                              .value =
                                                          LatLng(
                                                              element['properties']
                                                                  ['lat'],
                                                              element['properties']
                                                                  ['lon']);
                                                      locationController
                                                          .addressAvaiable
                                                          .value = true;
                                                      locationController
                                                          .pincodeSuggestions
                                                          .clear();
                                                      // searchedAdd.value = true;
                                                    },
                                                    style: const ButtonStyle(
                                                        alignment: Alignment
                                                            .centerLeft),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        '${element['properties']['postcode']} ${element['properties']['suburb'] != null ? element['properties']['suburb'] : ''} ${element['properties']['city']}',
                                                        style:
                                                            TextStyles.bodyFont,
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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
                  Visibility(
                    visible: locationController.addressAvaiable.value,
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: locationController.error.value
                          ? AppColors.grey
                          : AppColors.primeColor,
                      centerTitle: true,
                      title: ListTile(
                        title: Text(
                          'Save & Continue',
                          style: TextStyles.bodyFont
                              .copyWith(color: AppColors.white),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          if (!locationController.error.value) {
                            try {
                              if (Navigator.canPop(context))
                                Navigator.pop(context);
                              else
                                Modular.to.pushReplacementNamed('/home/main');
                            } catch (e) {
                              Modular.to.pushReplacementNamed('/home/main');
                              // code that handles the exception
                            }
                          }
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
          onPressed: () async {},
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
            (locationController.address['properties'] != null &&
                    locationController.address['properties']['formatted'] !=
                        null &&
                    !locationController.error.value)
                ? Text(
                    '${locationController.address['properties']['formatted']}' ??
                        '',
                    style: TextStyles.titleFont,
                  )
                : (locationController.error.value
                    ? Text('Invalid Pincode')
                    : LinearProgressIndicator(
                        color: AppColors.primeColor,
                      )),
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
