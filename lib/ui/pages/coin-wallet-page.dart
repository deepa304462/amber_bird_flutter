import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/coin_wallet/all_transaction.dart';
import 'package:amber_bird/data/coin_wallet/coin_wallet.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  coinWallet.value.totalActiveCoins != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Total S-COINS',
                              style: TextStyles.headingFont
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              coinWallet.value.totalActiveCoins.toString() ??
                                  '',
                              style: TextStyles.titleFont
                                  .copyWith(color: Colors.white),
                            )
                          ],
                        )
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
                                    'Pending S-COINS: ${coinWallet.value.totalPendingCoins} ',
                                    style: TextStyles.headingFont
                                        .copyWith(color: AppColors.primeColor),
                                  ),
                                ]),
                          ),
                        )
                      : const SizedBox(),
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
                    },
                  ),
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
                  'Comment: ${curTransaction.comment ?? 'No comments'}',
                  style: TextStyles.bodyFont,
                ),
                Text(
                  curTransaction.status!,
                  style: TextStyles.bodyFontBold,
                ),
              ]),
              Row(
                children: [
                  const Text('S-COINS: '),
                  Text(
                    '${curTransaction.amount!}',
                    style: TextStyles.headingFont.copyWith(color: Colors.blue),
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
