import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
            ITextBox('Full Name'),
            const SizedBox(
              height: 10,
            ),
            ITextBox('Mobile'),
            const SizedBox(
              height: 10,
            ),
            ITextBox('Email'),
            const SizedBox(
              height: 10,
            ),
            ITextBox('Password'),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [Icon(Icons.facebook), Icon(Icons.fingerprint)],
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Verify',
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
  }
}
