import 'package:amber_bird/ui/widget/payment-status-widget.dart';
import 'package:flutter/material.dart';

class PaymentSatusPage extends StatelessWidget {
  final String id;
  final String paymentId;
  PaymentSatusPage(this.id, this.paymentId);
  @override
  Widget build(BuildContext context) {
    return Column(children: [PaymentStatusWidget(id, paymentId)]);
  }
}
