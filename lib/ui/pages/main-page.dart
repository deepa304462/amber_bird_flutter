import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/category-row.dart';
import 'package:amber_bird/ui/widget/deal-row.dart';
import 'package:amber_bird/ui/widget/search-widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class MainPage extends StatefulWidget {
//   MainPage({Key? key}) : super(key: key);

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
class MainPage extends StatelessWidget {
  // final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          
          CategoryRow(),
          DealRow(dealName.FLASH),
          DealRow(dealName.SALES),
        ],
      ),
    );
  }
}
