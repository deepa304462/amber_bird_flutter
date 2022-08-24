import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top:250,left:20,right: 20),
            child: Column(children: [
              Text(
                "Set Your Delivery Location",
                style: TextStyles.titleXLargeBold,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Let us know the location to which you want your orders to be deliered",
                style: TextStyles.bodyFont,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.location_searching,
                  color: Colors.white,
                  size: 30.0,
                ),
                label: Text('Use my current location',
                    style: TextStyles.bodyWhite),
                onPressed: () {
                  print('Button Pressed');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primeColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: TextStyles.bodyWhite),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 30.0,
                ),
                label: Text('Selct Location from map',style: TextStyles.bodyWhite,),
                onPressed: () {
                  print('Button Pressed');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primeColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: TextStyles.bodyWhite),
              ),
            ]),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 35, 25, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkOrange,
                    textStyle: TextStyles.bodyWhite),
                onPressed: () {
                  SharedData.save('true','onboardingDone');
                  Modular.to.navigate('/home/main');
                },
                child: Text(
                  "Skip for now",
                  style: TextStyles.bodyWhite,
                ),
                // color: Colors.white.withOpacity(0.01),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
