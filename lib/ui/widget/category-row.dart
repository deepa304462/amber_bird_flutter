import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/shimmer-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryRow extends StatelessWidget {
  late MegaMenuController megaMenuController;
  // final CategoryController categoryController = Get.put(CategoryController());
  final Controller myController = Get.find();
  CategoryRow() {
    megaMenuController = ControllerGenerator.create(MegaMenuController(),
        tag: 'megaMenuController');
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: 75,
        child: !megaMenuController.isLoading.value
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: megaMenuController.catList.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            megaMenuController.selectedParentTab.value =
                                megaMenuController.catList[index].id ?? '';
                            megaMenuController.getSubMenu(GenericTab(
                                id: megaMenuController.catList[index].id,
                                image: megaMenuController.catList[index].logoId,
                                text: megaMenuController
                                    .catList[index].name!.defaultText!.text,
                                type: 'CAT'));

                            myController.setCurrentTab(1);
                          },
                          child: ImageBox(
                            megaMenuController.catList[index].logoId!,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Center(
                          child: Text(
                            (megaMenuController.catList[index].name!
                                                .defaultText!.text ??
                                            '')
                                        .length >
                                    7
                                ? '${(megaMenuController.catList[index].name!.defaultText!.text ?? '').substring(0, 6)}...'
                                : megaMenuController.catList[index].name!
                                        .defaultText!.text ??
                                    '',
                            style: TextStyles.body,
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
            : ShimmerWidget(
                heightOfTheRow: 75, radiusOfcell: 50, widthOfCell: 50),
      );
    });
  }
}
