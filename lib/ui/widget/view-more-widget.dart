import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

class ViewMoreWidget extends StatelessWidget {
  final VoidCallback onTap;
  const ViewMoreWidget({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            'More',
            style: TextStyles.titleFont.copyWith(color: AppColors.primeColor),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.primeColor,
            size: 15,
          )
        ],
      ),
    );
  }
}
