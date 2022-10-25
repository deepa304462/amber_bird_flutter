import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String showPrice;
  final String realPrice;
  const PriceTag(this.showPrice, this.realPrice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      verticalDirection: VerticalDirection.up,
      children: [
        Text(
          "${CodeHelp.euro}${showPrice}",
          style: TextStyles.titleLargeBold,
        ),
        const SizedBox(width: 3),
        Visibility(
          visible: realPrice != '' ? true : false,
          child: Text(
            "${realPrice}",
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: true),
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
