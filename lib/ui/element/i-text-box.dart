import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ITextBox extends StatefulWidget {
  final String label;
  ITextBox(this.label);
  @override
  State<StatefulWidget> createState() {
    return _ITextBox();
  }
}

class _ITextBox extends State<ITextBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primeColor)),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: this.widget.label,
        ),
        controller: new TextEditingController(),
      ),
    );
  }
}
