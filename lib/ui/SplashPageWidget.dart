import 'package:amber_bird/data/slider-item.dart';
import 'package:amber_bird/ui/widget/login-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class LoginPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

/**
  
 Text(AppLocalizations.of(context)!.helloWorld),
              IconButton(
                icon: Icon(Icons.access_alarm),
                onPressed: () {
                  ChangeLocale.change(Locale('es'));
                },
              ),
 */
class _LoginPage extends State<LoginPageWidget> {
  List<SliderItem> imgList = [];

  @override
  void initState() {
    imgList.add(addSliderItem(
        'https://cdn.diago-app.com/9380446b-ab02-47b1-a59e-5e2d14598763',
        'Overall patient care',
        'Access nearby hospital for any kind of heath issues.'));
    imgList.add(addSliderItem(
        'https://cdn.diago-app.com/3f7ada08-a79b-4bb6-8efe-d6d35604cfb4',
        'Call emergency service',
        'Easily call emergency service from your nearby hospital.'));
    imgList.add(addSliderItem(
        'https://cdn.diago-app.com/d29aa634-176e-4060-9e48-4726a9f06b06',
        'Online consunltation',
        'Ask your doctor about health issues from anywhere.'));
    imgList.add(addSliderItem(
        'https://cdn.diago-app.com/38cd7f68-6599-48d5-99dd-e77ca14c09f2',
        'Insurance AI',
        'Check & book appointment with doctor as per your insurance facilitate you.'));
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          final double width = MediaQuery.of(context).size.width;
          return Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: height,

                  viewportFraction: 1.0,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  // autoPlay: false,
                ),
                items: imgList
                    .map((item) => Center(
                            child: Stack(
                          children: [
                            Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              height: height,
                              width: width,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                borderOnForeground: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                        width: 2,
                                        color: Colors.white,
                                        style: BorderStyle.solid)),
                                color: Colors.black.withOpacity(.3),
                                child: ListTile(
                                  title: Text(
                                    item.title,
                                    style: TextStyles.titleXLargeWhite,
                                  ),
                                  subtitle: Text(
                                    item.desc,
                                    style: TextStyles.bodyWhiteLarge,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )))
                    .toList(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: LoginWidget(),
              ),
            ],
          );
        },
      )),
    );
  }

  SliderItem addSliderItem(String s, String t, String u) {
    return SliderItem(imageUrl: s, desc: u, title: t);
  }
}
