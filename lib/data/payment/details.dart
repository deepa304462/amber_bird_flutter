import 'dart:convert';

import 'package:amber_bird/data/payment/amount.dart';

import 'giftcard.dart';
import 'qr_code.dart';

class Details {
  String? cardNumber;
  String? cardFingerprint;
  String? bankname;
  String? bankAccount;
  String? bankBic;
  String? transferReference;
  String? consumerName;
  String? consumerAccount;
  String? consumerBic;
  String? billingEmail;
  String? bitcoinAddress;
  Amount? bitcoinAmount;
  String? bitcoinUri;
  String? cardHolder;
  String? carNumber;
  String? cardAudience;
  String? cardLabel;
  String? cardCountryCode;
  String? cardSecurity;
  String? feeRegion;
  String? failureReason;
  String? voucherNumber;
  List<Giftcard>? giftcards;
  Amount? remainderAmount;
  String? remainderMethod;
  String? paypalReference;
  String? customerReference;
  String? creditorIdentifier;
  String? dueDate;
  String? signatureDate;
  String? bankReasonCode;
  String? bankReason;
  String? endToEndIdentifier;
  String? mandateReference;
  String? batchReference;
  String? fileReference;
  QrCode? qrCode;

  Details({
    this.cardNumber,
    this.cardFingerprint,
    this.bankname,
    this.bankAccount,
    this.bankBic,
    this.transferReference,
    this.consumerName,
    this.consumerAccount,
    this.consumerBic,
    this.billingEmail,
    this.bitcoinAddress,
    this.bitcoinAmount,
    this.bitcoinUri,
    this.cardHolder,
    this.carNumber,
    this.cardAudience,
    this.cardLabel,
    this.cardCountryCode,
    this.cardSecurity,
    this.feeRegion,
    this.failureReason,
    this.voucherNumber,
    this.giftcards,
    this.remainderAmount,
    this.remainderMethod,
    this.paypalReference,
    this.customerReference,
    this.creditorIdentifier,
    this.dueDate,
    this.signatureDate,
    this.bankReasonCode,
    this.bankReason,
    this.endToEndIdentifier,
    this.mandateReference,
    this.batchReference,
    this.fileReference,
    this.qrCode,
  });

  @override
  String toString() {
    return 'Details(cardNumber: $cardNumber, cardFingerprint: $cardFingerprint, bankname: $bankname, bankAccount: $bankAccount, bankBic: $bankBic, transferReference: $transferReference, consumerName: $consumerName, consumerAccount: $consumerAccount, consumerBic: $consumerBic, billingEmail: $billingEmail, bitcoinAddress: $bitcoinAddress, bitcoinAmount: $bitcoinAmount, bitcoinUri: $bitcoinUri, cardHolder: $cardHolder, carNumber: $carNumber, cardAudience: $cardAudience, cardLabel: $cardLabel, cardCountryCode: $cardCountryCode, cardSecurity: $cardSecurity, feeRegion: $feeRegion, failureReason: $failureReason, voucherNumber: $voucherNumber, giftcards: $giftcards, remainderAmount: $remainderAmount, remainderMethod: $remainderMethod, paypalReference: $paypalReference, customerReference: $customerReference, creditorIdentifier: $creditorIdentifier, dueDate: $dueDate, signatureDate: $signatureDate, bankReasonCode: $bankReasonCode, bankReason: $bankReason, endToEndIdentifier: $endToEndIdentifier, mandateReference: $mandateReference, batchReference: $batchReference, fileReference: $fileReference, qrCode: $qrCode)';
  }

  factory Details.fromMap(Map<String, dynamic> data) => Details(
        cardNumber: data['cardNumber'] as String?,
        cardFingerprint: data['cardFingerprint'] as String?,
        bankname: data['bankname'] as String?,
        bankAccount: data['bankAccount'] as String?,
        bankBic: data['bankBic'] as String?,
        transferReference: data['transferReference'] as String?,
        consumerName: data['consumerName'] as String?,
        consumerAccount: data['consumerAccount'] as String?,
        consumerBic: data['consumerBic'] as String?,
        billingEmail: data['billingEmail'] as String?,
        bitcoinAddress: data['bitcoinAddress'] as String?,
        bitcoinAmount: data['bitcoinAmount'] == null
            ? null
            : Amount.fromMap(data['bitcoinAmount'] as Map<String, dynamic>),
        bitcoinUri: data['bitcoinUri'] as String?,
        cardHolder: data['cardHolder'] as String?,
        carNumber: data['carNumber'] as String?,
        cardAudience: data['cardAudience'] as String?,
        cardLabel: data['cardLabel'] as String?,
        cardCountryCode: data['cardCountryCode'] as String?,
        cardSecurity: data['cardSecurity'] as String?,
        feeRegion: data['feeRegion'] as String?,
        failureReason: data['failureReason'] as String?,
        voucherNumber: data['voucherNumber'] as String?,
        giftcards: (data['giftcards'] as List<dynamic>?)
            ?.map((e) => Giftcard.fromMap(e as Map<String, dynamic>))
            .toList(),
        remainderAmount: data['remainderAmount'] == null
            ? null
            : Amount.fromMap(data['remainderAmount'] as Map<String, dynamic>),
        remainderMethod: data['remainderMethod'] as String?,
        paypalReference: data['paypalReference'] as String?,
        customerReference: data['customerReference'] as String?,
        creditorIdentifier: data['creditorIdentifier'] as String?,
        dueDate: data['dueDate'] as String?,
        signatureDate: data['signatureDate'] as String?,
        bankReasonCode: data['bankReasonCode'] as String?,
        bankReason: data['bankReason'] as String?,
        endToEndIdentifier: data['endToEndIdentifier'] as String?,
        mandateReference: data['mandateReference'] as String?,
        batchReference: data['batchReference'] as String?,
        fileReference: data['fileReference'] as String?,
        qrCode: data['qrCode'] == null
            ? null
            : QrCode.fromMap(data['qrCode'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'cardNumber': cardNumber,
        'cardFingerprint': cardFingerprint,
        'bankname': bankname,
        'bankAccount': bankAccount,
        'bankBic': bankBic,
        'transferReference': transferReference,
        'consumerName': consumerName,
        'consumerAccount': consumerAccount,
        'consumerBic': consumerBic,
        'billingEmail': billingEmail,
        'bitcoinAddress': bitcoinAddress,
        'bitcoinAmount': bitcoinAmount?.toMap(),
        'bitcoinUri': bitcoinUri,
        'cardHolder': cardHolder,
        'carNumber': carNumber,
        'cardAudience': cardAudience,
        'cardLabel': cardLabel,
        'cardCountryCode': cardCountryCode,
        'cardSecurity': cardSecurity,
        'feeRegion': feeRegion,
        'failureReason': failureReason,
        'voucherNumber': voucherNumber,
        'giftcards': giftcards?.map((e) => e.toMap()).toList(),
        'remainderAmount': remainderAmount?.toMap(),
        'remainderMethod': remainderMethod,
        'paypalReference': paypalReference,
        'customerReference': customerReference,
        'creditorIdentifier': creditorIdentifier,
        'dueDate': dueDate,
        'signatureDate': signatureDate,
        'bankReasonCode': bankReasonCode,
        'bankReason': bankReason,
        'endToEndIdentifier': endToEndIdentifier,
        'mandateReference': mandateReference,
        'batchReference': batchReference,
        'fileReference': fileReference,
        'qrCode': qrCode?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Details].
  factory Details.fromJson(String data) {
    return Details.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Details] to a JSON string.
  String toJson() => json.encode(toMap());

  Details copyWith({
    String? cardNumber,
    String? cardFingerprint,
    String? bankname,
    String? bankAccount,
    String? bankBic,
    String? transferReference,
    String? consumerName,
    String? consumerAccount,
    String? consumerBic,
    String? billingEmail,
    String? bitcoinAddress,
    Amount? bitcoinAmount,
    String? bitcoinUri,
    String? cardHolder,
    String? carNumber,
    String? cardAudience,
    String? cardLabel,
    String? cardCountryCode,
    String? cardSecurity,
    String? feeRegion,
    String? failureReason,
    String? voucherNumber,
    List<Giftcard>? giftcards,
    Amount? remainderAmount,
    String? remainderMethod,
    String? paypalReference,
    String? customerReference,
    String? creditorIdentifier,
    String? dueDate,
    String? signatureDate,
    String? bankReasonCode,
    String? bankReason,
    String? endToEndIdentifier,
    String? mandateReference,
    String? batchReference,
    String? fileReference,
    QrCode? qrCode,
  }) {
    return Details(
      cardNumber: cardNumber ?? this.cardNumber,
      cardFingerprint: cardFingerprint ?? this.cardFingerprint,
      bankname: bankname ?? this.bankname,
      bankAccount: bankAccount ?? this.bankAccount,
      bankBic: bankBic ?? this.bankBic,
      transferReference: transferReference ?? this.transferReference,
      consumerName: consumerName ?? this.consumerName,
      consumerAccount: consumerAccount ?? this.consumerAccount,
      consumerBic: consumerBic ?? this.consumerBic,
      billingEmail: billingEmail ?? this.billingEmail,
      bitcoinAddress: bitcoinAddress ?? this.bitcoinAddress,
      bitcoinAmount: bitcoinAmount ?? this.bitcoinAmount,
      bitcoinUri: bitcoinUri ?? this.bitcoinUri,
      cardHolder: cardHolder ?? this.cardHolder,
      carNumber: carNumber ?? this.carNumber,
      cardAudience: cardAudience ?? this.cardAudience,
      cardLabel: cardLabel ?? this.cardLabel,
      cardCountryCode: cardCountryCode ?? this.cardCountryCode,
      cardSecurity: cardSecurity ?? this.cardSecurity,
      feeRegion: feeRegion ?? this.feeRegion,
      failureReason: failureReason ?? this.failureReason,
      voucherNumber: voucherNumber ?? this.voucherNumber,
      giftcards: giftcards ?? this.giftcards,
      remainderAmount: remainderAmount ?? this.remainderAmount,
      remainderMethod: remainderMethod ?? this.remainderMethod,
      paypalReference: paypalReference ?? this.paypalReference,
      customerReference: customerReference ?? this.customerReference,
      creditorIdentifier: creditorIdentifier ?? this.creditorIdentifier,
      dueDate: dueDate ?? this.dueDate,
      signatureDate: signatureDate ?? this.signatureDate,
      bankReasonCode: bankReasonCode ?? this.bankReasonCode,
      bankReason: bankReason ?? this.bankReason,
      endToEndIdentifier: endToEndIdentifier ?? this.endToEndIdentifier,
      mandateReference: mandateReference ?? this.mandateReference,
      batchReference: batchReference ?? this.batchReference,
      fileReference: fileReference ?? this.fileReference,
      qrCode: qrCode ?? this.qrCode,
    );
  }
}
