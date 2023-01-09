import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/location-text-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class AddAddress extends StatelessWidget {
  bool isLoading = false;
  final Controller myController = Get.find();
  final LocationController locationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
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
                  locationController.changeAddressData.value.name.toString(),
                  TextInputType.text,
                  callback),
              const SizedBox(
                height: 10,
              ),
              LocationTextBox(
                  'Line1',
                  'line1',
                  locationController.changeAddressData.value.line1.toString(),
                  TextInputType.text,
                  callback),
              const SizedBox(
                height: 10,
              ),
              LocationTextBox(
                  'Line2',
                  'line2',
                  locationController.changeAddressData.value.line2.toString(),
                  TextInputType.text,
                  callback),
              const SizedBox(
                height: 10,
              ),
              LocationTextBox(
                  'City',
                  'city',
                  locationController.changeAddressData.value.city.toString(),
                  TextInputType.text,
                  callback),
              const SizedBox(
                height: 10,
              ),
              LocationTextBox(
                  'Country',
                  'country',
                  locationController.changeAddressData.value.country.toString(),
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
                  locationController.changeAddressData.value.zipCode.toString(),
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
                      // Navigator.of(context).pop();
                      Modular.to.navigate('/home/address-list');
                      // Modular.to.navigate('/home/add-address');
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
                    onPressed: () async {
                      locationController.addressData.value =
                          locationController.changeAddressData.value;
                      await locationController.setAddressCall();
                      //  Navigator.of(context).pop();
                      Modular.to.navigate('/home/address-list');
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
    );
  }

  callback(String p1) {}
}
