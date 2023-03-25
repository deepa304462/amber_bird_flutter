import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../controller/google-address-suggest-controller.dart';

class GoogleAddressSuggest extends StatelessWidget {
  late GoogleAddressSuggestController controller;
  LocationController locationController = Get.find();
  TextEditingController _textController = TextEditingController();
  GoogleAddressSuggest({Key? key}) : super(key: key) {
    controller = ControllerGenerator.create(GoogleAddressSuggestController(),
        tag: 'googleAddressSuggestController');
  }

  @override
  Widget build(BuildContext context) {
    controller.addressSuggestions.clear();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primeColor,
        title: Text('Search address',
            style: TextStyles.bodyFont.copyWith(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  labelText: "Search your home address",
                  hintText: "Type home address",
                  suffixIcon: InkWell(
                      onTap: () {
                        _textController.clear();
                        controller.addressSuggestions.clear();
                      },
                      child: const Icon(Icons.clear))),
              controller: _textController,
              onChanged: (String changedText) {
                controller.search(
                    changedText, locationController.pinCode.value);
              },
            ),
            Expanded(
              child: Obx(
                () => ListView(
                  shrinkWrap: true,
                  children: controller.addressSuggestions
                      .map(
                        (element) => TextButton(
                          onPressed: () {
                            locationController.updateCustomerAddress(element);
                            Modular.to.pop(element);
                          },
                          style: const ButtonStyle(
                              alignment: Alignment.centerLeft),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${element['formatted_address']}',
                              style: TextStyles.bodyFont,
                              textAlign: TextAlign.right,
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
    );
  }
}
