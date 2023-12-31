import 'dart:math';

import 'package:amber_bird/data/hash_tag.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import 'package:get/get.dart';

class WordCloud extends StatelessWidget {
  RxList<Widget> widgets = <Widget>[].obs;
  List colorList = [
    AppColors.electricBlue,
    AppColors.coralPink,
    AppColors.violetPurple,
    AppColors.mintGreen,
    AppColors.goldenYellow,
    AppColors.royalPurple,
    AppColors.tealBlue,
    AppColors.salmonPink,
    AppColors.deepRed,
    AppColors.neonGreen
  ];

  getProductTags() async {
    print(widgets.length);
    if (widgets.length <= 0) {
      var responseProd =
          await ClientService.post(path: 'product/get100HashTags', payload: {});
      if (responseProd.statusCode == 200) {
        Random random = new Random();
        HashTag summaryProdList =
            HashTag.fromMap(responseProd.data as Map<String, dynamic>);

        for (var i = 0; i < summaryProdList.lessSale!.length; i++) {
          widgets.add(ScatterItem(
              FlutterHashtag(
                  summaryProdList.lessSale![i],
                  colorList[random.nextInt(9)],
                  random.nextInt(20) + 20,
                  random.nextInt(2) == 0 ? false : true),
              i));
        }
        for (var i = 0; i < summaryProdList.shortExpiry!.length; i++) {
          widgets.add(ScatterItem(
              FlutterHashtag(
                  summaryProdList.shortExpiry![i],
                  colorList[random.nextInt(9)],
                  random.nextInt(15) + 20,
                  random.nextInt(2) == 0 ? false : true),
              i));
        }
        for (var i = 0; i < summaryProdList.intentionalPush!.length; i++) {
          widgets.add(ScatterItem(
              FlutterHashtag(
                  summaryProdList.intentionalPush![i],
                  colorList[random.nextInt(9)],
                  random.nextInt(10) + 20,
                  random.nextInt(2) == 0 ? false : true),
              i));
        }
        for (var i = 0; i < summaryProdList.remainingTags!.length; i++) {
          if (widgets.length < 90) {
            widgets.add(ScatterItem(
                FlutterHashtag(
                    summaryProdList.remainingTags![i],
                    colorList[random.nextInt(9)],
                    random.nextInt(6) + 20,
                    random.nextInt(2) == 0 ? false : true),
                i));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getProductTags();

    return Container(
      color: Colors.white,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '#Tags',
                style: TextStyles.headingFont,
              ),
            ],
          ),
        ),
        Center(
          child: Obx(
            () => widgets.length > 0
                ? FittedBox(
                    fit: BoxFit.contain,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Scatter(
                        fillGaps: false,
                        alignment: Alignment.center,
                        delegate: ArchimedeanSpiralScatterDelegate(
                            a: .2, b: 1, step: 1 / 50),
                        children: widgets,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        )
      ]),
    );
  }
}

class ScatterItem extends StatelessWidget {
  ScatterItem(this.hashtag, this.index);
  final FlutterHashtag hashtag;
  final int index;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyles.titleFont.copyWith(
      fontSize: hashtag.size.toDouble(),
      color: hashtag.color,
    );
    return RotatedBox(
      quarterTurns: 1,
      child: InkWell(
        onTap: () {
          Modular.to
              .navigate('/widget/tag-product', arguments: hashtag.hashtag);
        },
        child: Text(
          hashtag.hashtag,
          style: style,
        ),
      ),
    );
  }
}

class FlutterHashtag {
  const FlutterHashtag(
    this.hashtag,
    this.color,
    this.size,
    this.rotated,
  );
  final String hashtag;
  final Color color;
  final int size;
  final bool rotated;
}

// class FlutterColors {
//   const FlutterColors._();

//   static const Color yellow = Color(0xFFFFC108);

//   static const Color white = Color(0xFFFFFFFF);

//   static const Color blue400 = Color(0xFF13B9FD);
//   static const Color blue600 = Color(0xFF0175C2);
//   static const Color blue = Color(0xFF02569B);

//   static const Color gray100 = Color(0xFFD5D7DA);
//   static const Color gray600 = Color(0xFF60646B);
//   static const Color gray = Color(0xFF202124);
// }
