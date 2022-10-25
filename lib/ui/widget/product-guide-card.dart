import 'package:amber_bird/data/product_guide/product_guide.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get_core/src/get_main.dart';

class ProductGuideCard extends StatelessWidget {
  final ProductGuide guide;
  ProductGuideCard(this.guide, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Modular.to.pushNamed('guide/${guide.id}');
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(4),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AbsorbPointer(
                child: ImageSlider(
                  guide.images!,
                  220,
                  disableTap: true,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  color: Colors.black.withOpacity(.4),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        guide!.subject!.defaultText!.text!,
                        style: TextStyles.titleXLargeWhite,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
