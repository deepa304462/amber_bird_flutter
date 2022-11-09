import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class ProfileWidget extends StatelessWidget {
  final Controller stateController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: () {
                  Modular.to.navigate('../home/main');
                },
                icon: const Icon(Icons.arrow_back))
          ]),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Email', style: TextStyles.bodyFont),
                    Text(stateController.loggedInProfile.value.email ?? '',
                        style: TextStyles.bodyFontBold),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Email verified', style: TextStyles.bodyFont),
                    Switch(
                      value: stateController.isEmailVerified.value,
                      onChanged: null,
                    ),
                    !stateController.isEmailVerified.value
                        ? TextButton(
                            onPressed: () async {
                              var data = await stateController.resendMail();
                              if (data != null) {
                                snackBarClass.showToast(context, data['msg']);
                              }
                            },
                            child: Text('Verify Mail',
                                style: TextStyles.bodyGreen),
                          )
                        : const SizedBox()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Mobile verified'),
                    Switch(
                      value: stateController.isPhoneVerified.value,
                      onChanged: null,
                    ),
                    !stateController.isPhoneVerified.value
                        ? TextButton(
                            onPressed: () async {
                              var data = await stateController.resendMail();
                              if (data != null) {
                                snackBarClass.showToast(context, data['msg']);
                              }
                            },
                            child: Text('Verify Mobile',
                                style: TextStyles.bodyGreen),
                          )
                        : const SizedBox()
                  ],
                ),
              ],
            ),
          ),
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(8.0),
              child: SizedBox())
        ],
      ),
    );
  }
}
