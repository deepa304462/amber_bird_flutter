import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class AppbarScrollController extends GetxController {
  ScrollController scrollController = ScrollController();

  RxBool navigatedToInnerPage = false.obs;
  RxBool shrinkappbar = false.obs;


  Rx<double> extentBefore = 0.0.obs;

  void _onScrollEvent() {
    final extentAfter1 = scrollController.position.extentAfter;
    extentBefore.value =scrollController.position.extentBefore;
    if(extentBefore.value > 70){
      shrinkappbar.value = true;
    }else{
      shrinkappbar.value = false;
    }
    print("Extent after: $extentAfter1");
    print("Extent before: ${scrollController.position.extentBefore}");
  }

  @override
  void onInit() {
    scrollController.addListener(_onScrollEvent);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScrollEvent);

    super.dispose();
  }

  navigateTo(String path){
     Modular.to.navigate(path);
     shrinkappbar.value = false;
  }

  navigateToPop(BuildContext context) {
    Navigator.pop(context);
    shrinkappbar.value = false;
  }
}
