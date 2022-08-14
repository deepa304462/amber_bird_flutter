import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(builder: (mController) {
      return Card(
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sign Up',
                style: TextStyles.titleXLargePrimary,
              ),
              const SizedBox(
                height: 10,
              ),
              ITextBox('Full Name', mController.fieldValue['fullName'].toString(), false, TextInputType.text, false),
              const SizedBox(
                height: 10,
              ),
              ITextBox('Mobile',  mController.fieldValue['mobile'].toString(), false, TextInputType.number, false),
              const SizedBox(
                height: 10,
              ),
              ITextBox('Email',  mController.fieldValue['email'].toString(), false, TextInputType.emailAddress, false),
              const SizedBox(
                height: 10,
              ),
              ITextBox(
                  'Password', mController.fieldValue['password'].toString(), false, TextInputType.visiblePassword, true),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: ()   {
                   mController.signInWithGoogle();
                 
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Sign up',
                  style: TextStyles.bodyWhiteLarge,
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.primeColor)),
              )
            ],
          ),
        ),
      );
    });
  }
}
