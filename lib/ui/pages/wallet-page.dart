import 'package:amber_bird/ui/pages/coin-wallet-page.dart';
import 'package:amber_bird/ui/pages/spoints-page.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          toolbarHeight: 50,
          leadingWidth: 50,
          backgroundColor: AppColors.primeColor,
          leading: MaterialButton(
            onPressed: () {
              // Navigator.pop(context);
              if (Modular.to.canPop()) {
                Navigator.pop(context);
                Modular.to.pop();
              } else if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Modular.to.navigate('../../home/main');
                // Modular.to.pushNamed('/home/main');
              }
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 15,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyles.body.copyWith(color: AppColors.white),
            tabs: [
              Tab(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      'S-COINS',
                      style: TextStyles.bodyFontBold
                          .copyWith(color: AppColors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/scoin.png',
                          height: 15,
                          fit: BoxFit.fill,
                          colorBlendMode: BlendMode.color),
                    ),
                  ])),
              Tab(
                child: Text(
                  'S-POINTS',
                  style:
                      TextStyles.bodyFontBold.copyWith(color: AppColors.white),
                ),
              )
            ],
          ),
          title: Column(
            children: [
              Text(
                'My Wallet',
                style: TextStyles.bodyFont.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CoinWalletPage(),
            SpointsPage(),
          ],
        ),
      ),
    );
  }
}
