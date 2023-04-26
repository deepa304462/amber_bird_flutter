import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/ui-style.dart';

class LoadingWithLogo extends StatelessWidget {
  const LoadingWithLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.white.withOpacity(.5),
          AppColors.off_red.withOpacity(.5),
        ],
      )),
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * .24,
            left: MediaQuery.of(context).size.width * .13,
            child: Lottie.asset('assets/loading-bg.json',
                width: MediaQuery.of(context).size.width * .8,
                fit: BoxFit.cover),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .33,
            left: MediaQuery.of(context).size.width * .37,
            child: Image.asset('assets/insidelogo.png',
                width: MediaQuery.of(context).size.width * .2,
                fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
