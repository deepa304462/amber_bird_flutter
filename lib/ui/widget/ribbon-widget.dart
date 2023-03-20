import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom-clipper.dart';

class RibbonWidget extends StatelessWidget {
  final text;
  const RibbonWidget({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: ClipPath(
            clipper: ArcClipper(),
            child: Container(
                width: 120.0,
                height: 30.0,
                padding: EdgeInsets.all(4.0),
                color: Colors.amber,
                child: Center(
                    child: Text(
                  text,
                  style: TextStyles.bodyFontBold.copyWith(color: Colors.white),
                ))),
          ),
        ),
        Positioned(
          bottom: 0.0,
          child: ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              width: 20.0,
              height: 20.0,
              color: Colors.amber.shade900,
            ),
          ),
        )
      ],
    );
  }
}
