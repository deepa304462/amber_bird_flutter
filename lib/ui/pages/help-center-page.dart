import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../helpers/controller-generator.dart';

class HelpCenterPage extends StatelessWidget {
  final Controller stateController = Get.find();
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        leadingWidth: 50,
        backgroundColor: AppColors.primeColor,
        leading: MaterialButton(
          onPressed: () {
            if (Modular.to.canPop()) {
              Modular.to.pop();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Modular.to.navigate('../../home/main');
            }
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 15,
          ),
        ),
        title: Column(
          children: [
            Text(
              'Help Center',
              style: TextStyles.bodyFont.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(5),
          color: AppColors.commonBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contact Us', style: TextStyles.headingFont),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: ImageBox(
                                        '316204af-0bc0-486d-81fb-55dd28e4674c',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Center(
                                        child: Flexible(
                                      child: Text('Return & refund',
                                          style: TextStyles.body),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Modular.to.pushNamed(
                                            '/widget/compilance/BUYER_PROTECTION');
                                      },
                                      child: ImageBox(
                                        '2229ac1f-3b17-4477-8970-d4441f5e6447',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Center(
                                      child: FitText('Customer Service',
                                          style: TextStyles.body),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: ImageBox(
                                        '82b731de-b1f2-49a2-ad4e-eb5ed0ccb0a3',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Center(
                                      child: FitText('Partnership',
                                          style: TextStyles.body),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: ImageBox(
                                        'a739ca3d-d626-4f84-9fa1-a4f92b53f970',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Center(
                                      child: FitText("We're Hiring!",
                                          style: TextStyles.body),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Need Immeddiate Assistance?',
                            style: TextStyles.headingFont),
                        ListTile(
                          leading: Icon(Icons.mail),
                          title: Text(
                            'Support at sbazar.app',
                            style: TextStyles.titleFont,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text(
                            '0049 176 35298960',
                            style: TextStyles.titleFont,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FAQ', style: TextStyles.headingFont),
                        ListTile(
                          title: Text(
                            'Mail Order FAQ',
                            style: TextStyles.titleFont,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                        ListTile(
                          title: Text(
                            'How to get a refund',
                            style: TextStyles.titleFont,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                        ListTile(
                          title: Text(
                            'Buy X get Y% Disccount promotion',
                            style: TextStyles.titleFont,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
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
