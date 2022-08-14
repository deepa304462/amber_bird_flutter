import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ITextBox extends StatelessWidget {
  final String label;
  final String value;
  final bool iscomingFromThridParty;
  final bool isPassword;
  final TextInputType keyboardType;
  ITextBox(
      this.label, this.value, this.iscomingFromThridParty, this.keyboardType, this.isPassword);
//   @override
//   State<StatefulWidget> createState() {
//     return _ITextBox();
//   }
// }

// class _ITextBox extends State<ITextBox> {
  @override
  Widget build(BuildContext context) {
    TextEditingController ipController = new TextEditingController();
    ipController.text = value ;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primeColor)),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
        ),
        controller: ipController,
        obscureText: isPassword,
        keyboardType: keyboardType,
      ),
    );
  }
}
