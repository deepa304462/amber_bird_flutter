import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

class IRadioBox extends StatelessWidget {
  final String label;
  final String value;
  final String keyName;
  final bool isDisabled;
  final List inputList;
  TextEditingController ipController = TextEditingController();
  Function callback;

  dynamic selectedVal;
  IRadioBox(this.label, this.keyName, this.value, this.inputList,
      this.isDisabled, this.callback) {
    ipController.text = value;
    ipController.selection = TextSelection.fromPosition(
        TextPosition(offset: ipController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    // ipController.text =
    //     value.split('-').length > 1 ? value.split('-')[1] : value;
    return Container(
      // height: 55,
      // padding: const EdgeInsets.fromLTRB(0, 2, 10, 2),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyles.headingFont,
          ),
          ListView.builder(
            itemCount: inputList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                dense: true,
                title: Text(inputList[index], style: TextStyles.titleFont),
                leading: Radio(
                  value: inputList[index],
                  groupValue: value,
                  onChanged: (dynamic value) {
                    callback(keyName, value);
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
