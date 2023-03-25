import 'package:amber_bird/ui/widget/web-page-viewer.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

class PrivacyHelpTermsSection extends StatelessWidget {
  const PrivacyHelpTermsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sectionCard('FAQ', 'Get answer for your specific query',
            () => {openWebPage('https://sbazar.store/faq.html', context)}),
        sectionCard('Help', 'Get help from our customer care team',
            () => {openWebPage('https://sbazar.store/help.html', context)}),
        sectionCard(
            'Privacy policy',
            'Explains legals and policies',
            () => {
                  openWebPage(
                      'https://sbazar.store/privacy-policy.html', context)
                }),
        sectionCard(
            'Terms and conditions',
            'Outlined the rules, regulations, and guidelines',
            () => {openWebPage('https://sbazar.store/terms.html', context)}),
        sectionCard(
            'Contact us',
            'Get connect with our support team',
            () =>
                {openWebPage('https://sbazar.store/contact-us.html', context)}),
        Text('Accepted payment methods', style: TextStyles.bodyFont),
        Image.asset(
          'assets/payment-methods.png',
          width: MediaQuery.of(context).size.width * .8,
        )
      ],
    );
  }

  Widget sectionCard(String title, String subtitle, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: ListTile(
            title: Text(
              title,
              style: TextStyles.headingFont,
            ),
            subtitle: Text(
              subtitle,
              style: TextStyles.bodyFont,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }

  openWebPage(String url, BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: WebPageViewer(url));
        });
  }
}
