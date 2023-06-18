import 'dart:math';

import 'package:amber_bird/data/hash_tag.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import 'package:get/get.dart';

// class TextApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Align(
//         alignment: Alignment.center,
//         child: Scatter(
//           alignment: Alignment.center,
//           delegate: AlignScatterDelegate(alignment: Alignment.topCenter),
//           children: List.generate(
//             4,
//             (i) => Container(
//               width: (i + 1) * 20.0,
//               height: (i + 1) * 20.0,
//               key: ValueKey(i),
//               color: i.isEven ? Colors.blue : Colors.orange,
//               child: Text('$i'),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class WordCloud extends StatelessWidget {
  RxList<Widget> widgets = <Widget>[].obs;
  List colorList = [
    AppColors.primeColor,
    AppColors.white,
    AppColors.darkOrange,
    AppColors.teal,
    AppColors.secondaryColor,
    AppColors.blue,
    AppColors.green,
    AppColors.cyan
  ];

  getProductTags() async {
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
                colorList[random.nextInt(6)],
                random.nextInt(20) + 20,
                random.nextInt(2) == 0 ? false : true),
            i));
      }
      for (var i = 0; i < summaryProdList.shortExpiry!.length; i++) {
        widgets.add(ScatterItem(
            FlutterHashtag(
                summaryProdList.shortExpiry![i],
                colorList[random.nextInt(6)],
                random.nextInt(15) + 20,
                random.nextInt(2) == 0 ? false : true),
            i));
      }
      for (var i = 0; i < summaryProdList.intentionalPush!.length; i++) {
        widgets.add(ScatterItem(
            FlutterHashtag(
                summaryProdList.intentionalPush![i],
                colorList[random.nextInt(6)],
                random.nextInt(10) + 20,
                random.nextInt(2) == 0 ? false : true),
            i));
      }
      for (var i = 0; i < summaryProdList.remainingTags!.length; i++) {
        if (widgets.length < 110) {
          widgets.add(ScatterItem(
              FlutterHashtag(
                  summaryProdList.remainingTags![i],
                  colorList[random.nextInt(6)],
                  random.nextInt(6) + 20,
                  random.nextInt(2) == 0 ? false : true),
              i));
        }
      }
      // for (var i = 0; i < kFlutterHashtags.length; i++) {
      //   widgets.add(ScatterItem(kFlutterHashtags[i], i));
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    getProductTags();

    final screenSize = MediaQuery.of(context).size;
    final ratio = screenSize.width * 2.5 / (screenSize.height / 2);

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
                ? SizedBox(
                    height: screenSize.width * 2,
                    width: screenSize.width * 2,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Scatter(
                          fillGaps: true,
                          delegate: ArchimedeanSpiralScatterDelegate(ratio: .5),
                          children: widgets,
                        ),
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
      fontSize: hashtag.size.toDouble() ?? 16,
      color: hashtag.color ?? AppColors.primeColor,
    );
    return RotatedBox(
      quarterTurns: hashtag.rotated ? 1 : 0,
      child: InkWell(
        onTap: () {
          Modular.to.pushNamed('/widget/tag-product/${hashtag.hashtag}');
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
 