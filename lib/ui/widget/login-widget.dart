import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginWidget();
  }
}

class _LoginWidget extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
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
            Image.network(
              'https://cdn2.sbazar.app/383ba026-222a-4a16-8c24-b6f7f7227630',
              width: 200,
              fit: BoxFit.cover,
            ),
            Text(
              'Get access',
              style: TextStyles.titleXLargePrimary,
            ),
            ITextBox('Registered contact number','mobile','',false, TextInputType.text,false,callback),
            TextButton(
              onPressed: () {},
              child: Text(
                'Verify',
                style: TextStyles.bodyWhiteLarge,
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.primeColor)),
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

  callback(String p1) {
  }
}
