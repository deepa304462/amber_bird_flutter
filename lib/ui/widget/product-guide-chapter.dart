import 'package:amber_bird/data/product_guide/chapter.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/ui/widget/show-more-text-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductGuideChapter extends StatelessWidget {
  Chapter chapter;
  ProductGuideChapter(this.chapter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            clipBehavior: Clip.hardEdge,
            shape: const RoundedRectangleBorder(
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
                        chapter.images!.length > 0
                            ? ImageBox(
                                chapter.images![0],
                                width: MediaQuery.of(context).size.width * .9,
                                height: 140,
                                fit: BoxFit.fitWidth,
                              )
                            : const SizedBox(),
                      ],
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          chapter.label!.defaultText!.text!,
                          style: TextStyles.body,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ShowMoreWidget(
                      text: chapter.subLabel!.defaultText!.text!, length: 200),
                ),
              ],
            ),
          ),
          MasonryGridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: chapter.products!.length,
            itemBuilder: (_, index) {
              var currentProduct = chapter.products![index];
              if (currentProduct.varient != null) {
                return ProductCard(
                    currentProduct,
                    currentProduct.id,
                    'GUIDE',
                    currentProduct.varient!.price!,
                    null,
                    currentProduct.varient!.constraint);
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
