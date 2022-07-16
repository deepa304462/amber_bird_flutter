import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

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
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              'https://cdn.diago-app.com/6239657a-f58d-4299-b16b-10911028319f',
              width: 200,
              fit: BoxFit.cover,
            ),
            Text(
              'Get access',
              style: TextStyles.titleXLarge,
            ),
            ITextBox('Registered contact number'),
            TextButton(
              onPressed: () {},
              child: Text(
                'Verify',
                style: TextStyles.bodyWhiteLarge,
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}
