import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

class FitText extends StatelessWidget {
  final String text;
  TextStyle style = TextStyles.bodyFont;
  TextAlign align = TextAlign.start;
  FitText(this.text,
      {TextStyle? style, TextAlign align = TextAlign.center, Key? key})
      : super(key: key) {
    if (style != null) {
      this.style = style;
    } else {
      this.style = TextStyles.bodyFont;
    }
  }

  @override
  Widget build(BuildContext context) {
    return text != null && text != ''
        ? FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: style,
              textAlign: align,
            ),
          )
        : const SizedBox();
  }
}
