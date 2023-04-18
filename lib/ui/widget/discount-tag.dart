import 'package:amber_bird/data/price/price.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

class DiscountTag extends StatelessWidget {
  final Price price;
  const DiscountTag({required this.price, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int discount = _calcDiscount();
    return Visibility(
      visible: discount > 0,
      child: Card(
        color: Colors.green,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              Text(
                '${discount}%',
                style: TextStyles.bodyFont
                    .copyWith(color: Colors.white, fontSize: 12),
              ),
              Icon(Icons.arrow_downward, size: 12, color: Colors.white)
            ],
          ),
        ),
      ),
    );
  }

  int _calcDiscount() {
    if (price.actualPrice == null || (price.actualPrice as double) == 0) {
      return 0;
    }
    return int.parse(
        ((((price.actualPrice as double) - (price.offerPrice as double)) *
                    100) /
                (price.actualPrice as double))
            .toStringAsFixed(0));
  }
}
