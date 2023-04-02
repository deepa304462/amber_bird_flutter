import 'package:amber_bird/ui/pages/coin-wallet-page.dart';
import 'package:amber_bird/ui/pages/spoints-page.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

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
          leadingWidth: 100,
          backgroundColor: AppColors.primeColor,
          leading: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyles.body.copyWith(color: AppColors.white),
            tabs: [
              Tab(
                child: Text(
                  'S-COINS',
                  style:
                      TextStyles.bodyFontBold.copyWith(color: AppColors.white),
                ),
              ),
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
                style: TextStyles.headingFont.copyWith(color: Colors.white),
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
