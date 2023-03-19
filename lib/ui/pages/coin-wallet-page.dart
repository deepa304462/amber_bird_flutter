import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/coin_wallet/all_transaction.dart';
import 'package:amber_bird/data/coin_wallet/coin_wallet.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/codehelp.dart';

class CoinWalletPage extends StatelessWidget {
  Rx<CoinWallet> coinWallet = CoinWallet().obs;

  getWallet() async {
    if (Get.isRegistered<Controller>()) {
      var controller = Get.find<Controller>();
      coinWallet.value = controller.customerDetail.value.coinWalletDetail!;
    }
  }

  @override
  Widget build(BuildContext context) {
    getWallet();
    return Obx(
      () => Column(
        children: [
          AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 50,
            leadingWidth: 100,
            backgroundColor: AppColors.primeColor,
            title: Column(
              children: [
                Text(
                  'My Wallet',
                  style: TextStyles.headingFont.copyWith(color: Colors.white),
                ),
              ],
            ),
            leading: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    Text(
                      'Back',
                      style: TextStyles.bodyFont.copyWith(color: Colors.white),
                    )
                  ],
                )),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.primeColor,
                AppColors.primeColor.withOpacity(.8),
              ],
            )),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      coinWallet.value.totalActiveCoins != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text(
                                    'Total scoins',
                                    style: TextStyles.headingFont
                                        .copyWith(color: Colors.white),
                                  ),
                                  Text(
                                    coinWallet.value.totalActiveCoins
                                            .toString() ??
                                        '',
                                    style: TextStyles.titleXLarge.copyWith(
                                        color: Colors.white, fontSize: 40),
                                  )
                                ])
                          : const SizedBox(),
                      coinWallet.value.totalPendingCoins != null
                          ? Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Pending scoins are ${coinWallet.value.totalPendingCoins} ',
                                        style: TextStyles.headingFont.copyWith(
                                            color: AppColors.primeColor),
                                      ),
                                    ]),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Lottie.asset('assets/coin.json',
                      height: 100, fit: BoxFit.fill, repeat: true)
                ],
              ),
            ),
          ),
          coinWallet.value.allTransactions != null &&
                  coinWallet.value.allTransactions!.length > 0
              ? Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: coinWallet.value.allTransactions!.length,
                      itemBuilder: (_, index) {
                        var currentTrnsaction =
                            coinWallet.value.allTransactions![index];
                        return TransactionTile(currentTrnsaction);
                      }),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget TransactionTile(AllTransaction curTransaction) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        margin: const EdgeInsets.all(2),
        child: ListTile(
          title: Text(
            Helper.formatStringPurpose(curTransaction.purpose!),
            style: TextStyles.headingFont,
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                FitText(
                  'Comment: ${curTransaction.comment}',
                  style: TextStyles.bodyFont,
                ),
                Text(
                  '${curTransaction.status!}',
                  style: TextStyles.bodyFontBold,
                ),
              ]),
              Row(
                children: [
                  Text('Scoins: '),
                  Text(
                    '${curTransaction.amount!}',
                    style: TextStyles.headingFontBlue,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
