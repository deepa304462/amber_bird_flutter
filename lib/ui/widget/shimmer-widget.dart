import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  double heightOfTheRow = 180;
  double widthOfCell = 120;
  double radiusOfcell = 12;

  ShimmerWidget(
      {required this.heightOfTheRow,
      required this.radiusOfcell,
      required this.widthOfCell,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: heightOfTheRow,
      child: Center(
        child: Shimmer.fromColors(
            // ignore: sort_child_properties_last
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                  4,
                  (index) => Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(radiusOfcell)),
                          child: Container(
                            width: widthOfCell,
                          ),
                        ),
                      )),
            ),
            baseColor: Colors.grey.shade100,
            period: const Duration(milliseconds: 3000),
            highlightColor: Colors.grey.shade300),
      ),
    );
  }
}
