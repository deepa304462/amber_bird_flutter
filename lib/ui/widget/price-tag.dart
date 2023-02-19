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
                "${CodeHelp.euro}${num.parse(showPrice).toStringAsFixed(2)}",
                style: TextStyles.titleLargeBold,
              ),
              const SizedBox(width: 3),
              Visibility(
                visible: realPrice != '' ? true : false,
                child: Text(
                  "${num.parse(realPrice).toStringAsFixed(2)}",
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

  Widget _showCoins() {
    return Text('${scoin}');
  }
}
