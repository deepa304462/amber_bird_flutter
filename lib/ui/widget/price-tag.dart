import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String showPrice;
  final String realPrice;
  int scoin = 0;
  PriceTag(this.showPrice, this.realPrice, {Key? key, this.scoin = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return scoin > 0
        ? _showCoins()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            verticalDirection: VerticalDirection.up,
            children: [
              Text(
                "${num.parse(showPrice).toStringAsFixed(2)}${CodeHelp.euro}",
                style: TextStyles.headingFont,
              ),
              const SizedBox(width: 3),
              Visibility(
                visible: realPrice != ''
                    ? num.parse(realPrice).toStringAsFixed(2) ==
                            num.parse(showPrice).toStringAsFixed(2)
                        ? false
                        : true
                    : false,
                child: Text(num.parse(realPrice).toStringAsFixed(2),
                    textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: true),
                    style: TextStyles.titleFont.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey)),
              ),
            ],
          );
  }

  Widget _showCoins() {
    return Row(
      children: [
        Text(
          '${scoin}',
          style: TextStyles.headingFont,
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset('assets/scoin.png',
              height: 15, fit: BoxFit.fill, colorBlendMode: BlendMode.color),
        ),
      ],
    );
  }
}
