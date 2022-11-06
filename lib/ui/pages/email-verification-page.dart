import 'package:flutter/material.dart';

class EmailVerificationPage extends StatelessWidget {
  final String email;
  final String code;
  const EmailVerificationPage(this.email, this.code, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [Text(email), Text(code)],
          ),
        ),
      ),
    );
  }
}
