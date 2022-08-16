import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class LoginWidget extends StatelessWidget {
  final AuthController authController = Get.find();
  final Controller controller = Get.find();

//   @override
//   State<StatefulWidget> createState() {
//     return _LoginWidget();
//   }
// }

// class _LoginWidget extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              'https://cdn2.sbazar.app/383ba026-222a-4a16-8c24-b6f7f7227630',
              width: 200,
              fit: BoxFit.cover,
            ),
            Text(
              'Get access',
              style: TextStyles.titleXLargePrimary,
            ),
            // ITextBox('Registered contact number', 'mobile', '', false,
            //     TextInputType.phone, false, callback),
            // const SizedBox(
            //   height: 10,
            // ),
            // const Center(
            //   child: Text('OR'),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            ITextBox('Email', 'email', '', false, TextInputType.emailAddress, false,
                callback),
            const SizedBox(
              height: 10,
            ),
            ITextBox('Password', 'password', '', false,
                TextInputType.visiblePassword, true, callback),
            TextButton(
              onPressed: () async{
                var data = await authController.login();
                print(data);
                if (data['status'] == 'success') {
                  controller.isLogin.value = true;
                  controller.setCurrentTab(0);
                }
                snackBarClass.showToast(context, data['msg']);
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.primeColor)),
              child: Text(
                'Login',
                style: TextStyles.bodyWhiteLarge,
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Modular.to.navigate('/signup');
                },
                child: Text(
                  'Sign up',
                  style: (TextStyles.titleGreen),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  callback(String p1) {}
}
