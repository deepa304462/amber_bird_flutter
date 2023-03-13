import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/coin_wallet/all_transaction.dart';
import 'package:amber_bird/data/coin_wallet/coin_wallet.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
                  Modular.to.navigate('../home/main');
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
           const SizedBox(
            height: 10,
          ),
          coinWallet.value.totalActiveCoins != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Text(
                        'Total Coin: ',
                        style: TextStyles.headingFont,
                      ),
                      Text(
                        coinWallet.value.totalActiveCoins.toString() ?? '',
                        style: TextStyles.headingFontGray,
                      )
                    ])
              : const SizedBox(),
          coinWallet.value.totalPendingCoins != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Text(
                        'Pending Coin: ',
                        style: TextStyles.headingFont,
                      ),
                      Text(coinWallet.value.totalPendingCoins.toString() ?? '',
                          style: TextStyles.headingFontGray)
                    ])
              : const SizedBox(),
          const SizedBox(
            height: 20,
          ),
          coinWallet.value.allTransactions!.length > 0
              ?  SingleChildScrollView(
                    child: SizedBox(
                    height: MediaQuery.of(context).size.height *0.6,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: coinWallet.value.allTransactions!.length,
                        itemBuilder: (_, index) {
                          var currentTrnsaction =
                              coinWallet.value.allTransactions![index];
                          return TransactionTile(currentTrnsaction);
                        }),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget TransactionTile(AllTransaction curTransaction) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
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
