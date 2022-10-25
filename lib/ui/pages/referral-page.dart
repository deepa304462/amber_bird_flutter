import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ReferralPage extends StatelessWidget {
  ReferralPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: Text(
            'Share & Earn Rewards',
            style: TextStyles.titleLargeBold,
          )),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width,
            child: Lottie.network(
                'https://cdn2.sbazar.app/26525fe0-b20f-4a8c-b9a5-50d6ec73c5f0',
                repeat: true),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Get ${CodeHelp.euro}9 for user you refer',
                  style: TextStyles.bodyPrimaryLarge.copyWith(
                      fontWeight: FontWeight.w900, color: AppColors.primeColor),
                ),
                Text(
                  'Share following link with your friends & family',
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyPrimaryLarge.copyWith(
                      fontWeight: FontWeight.normal, color: Colors.grey),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(width: 2, color: AppColors.primeColor)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'https://app.sbazar.app/refer/1abcdc',
                      style: TextStyles.bodyFontBold,
                    ),
                  ),
                ),
                const Divider(),
                MaterialButton(
                  onPressed: () {},
                  color: AppColors.primeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        Text(
                          'Share',
                          style: TextStyles.titleXLargeWhite
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          termsAndCondition(context)
        ],
      ),
    );
  }

  termsAndCondition(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: TextStyles.bodyPrimaryLarge,
            ),
            Text(
              '1. When your friend purchase something then you will get ${CodeHelp.euro}9 to your sbazar user account.',
              style: TextStyles.body,
            ),
            Text(
              '2. Offer can be change or limit.',
              style: TextStyles.body,
            )
          ],
        ),
      ),
    );
  }
}
