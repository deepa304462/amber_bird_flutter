import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String showPrice;
  final String realPrice;
  const PriceTag(this.showPrice, this.realPrice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "\$${showPrice}",
          style: TextStyles.bodyFontBold,
        ),
        const SizedBox(width: 3),
        Visibility(
          visible: realPrice != '' ? true : false,
          child: Text(
            "\$${realPrice}",
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
