import 'package:amber_bird/data/product_guide/chapter.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

class ProductGuideChapter extends StatelessWidget {
  Chapter chapter;
  ProductGuideChapter(this.chapter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Column(
                      children: [
                        ImageBox(
                          '${ClientService.cdnUrl}${chapter.images![0]}',
                          width: MediaQuery.of(context).size.width * .9,
                          height: 100,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          chapter.label!.defaultText!.text!,
                          style: TextStyles.titleLight,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    chapter.subLabel!.defaultText!.text!,
                    style: TextStyles.bodyFont,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: chapter.products!
                .map((e) => Card(
                    child: ProductCard(e, '', 'GUIDE', e.varient!.price, null)))
                .toList(),
          )
        ],
      ),
    );
  }
}
