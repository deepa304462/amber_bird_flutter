import 'package:flutter/material.dart';

import '../../utils/ui-style.dart';

class AddToCartButtons extends StatelessWidget {
  bool hideAdd;
  int quantity;
  Function onAdd;
  Function onIncrease;
  Function onDecrease;
  AddToCartButtons(
      {required this.hideAdd,
      required this.quantity,
      required this.onAdd,
      required this.onIncrease,
      required this.onDecrease,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hideAdd
        ? Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: AppColors.primeColor,
            margin: const EdgeInsets.all(0),
            child: Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  onPressed: () => onDecrease(),
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Text(
                  quantity.toString(),
                  style:
                      TextStyles.headingFont.copyWith(color: AppColors.white),
                ),
                IconButton(
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  onPressed: () => onIncrease(),
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          )
        : CircleAvatar(
            backgroundColor: AppColors.primeColor,
            radius: 15,
            child: IconButton(
              constraints: const BoxConstraints(),
              color: Colors.white,
              onPressed: () => onAdd(),
              icon: const Icon(
                Icons.add,
                size: 15,
                color: Colors.white,
              ),
            ),
          );
  }
}
