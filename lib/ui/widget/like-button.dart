import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/ui-style.dart';

class LikeButton extends StatefulWidget {
  Function onPressed;
  bool isLiked;
  LikeButton({required this.onPressed, required this.isLiked, Key? key})
      : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController lottieController;
  bool isAnimating = false;
  bool isLoaded = false;

  @override
  void initState() {
    lottieController = AnimationController(
      vsync: this,
    );
    lottieController.stop();
    lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isAnimating = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onPressed();
        if (isLoaded) {
          if (widget.isLiked) {
            lottieController.reverse();
          } else {
            lottieController.forward();
          }
        }
        setState(() {
          isAnimating = true;
        });
      },
      child: false
          ? Lottie.asset('assets/like.json',
              height: 50,
              fit: BoxFit.cover,
              controller: lottieController, onLoaded: (composition) {
              lottieController.duration = composition.duration;
              isLoaded = true;
              if (widget.isLiked) {
                lottieController.reverse();
              } else {
                lottieController.forward();
              }
            })
          : Icon(
              widget.isLiked ? Icons.favorite : Icons.favorite_outline,
              color: AppColors.primeColor,
            ),
    );
  }
}
