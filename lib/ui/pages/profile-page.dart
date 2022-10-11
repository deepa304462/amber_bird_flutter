import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final Controller stateController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Email', style: TextStyles.bodyFont),
              Text(stateController.tokenManagerEntityId.value,
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
                          var showToast =
                              snackBarClass.showToast(context, data['msg']);
                        }
                      },
                      child: Text('Verify Mail', style: TextStyles.bodyGreen))
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
            ],
          ),
          TextButton(
            onPressed: () async {
              stateController.logout();
            },
            child: Text("Logout",style: TextStyles.headingFont),
          ),
        ]));
  }
}
