import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/profile/ref.dart';

class AllTransaction {
  MetaData? metaData;
  Ref? profileRef;
  double? currentBalance;
  double? amount;
  String? transactionType;
  String? purpose;
  String? comment;
  Ref? purposeRef;
  String? businessId;
  String? status;
  String? id;

  AllTransaction({
    this.metaData,
    this.profileRef,
    this.currentBalance,
    this.amount,
    this.transactionType,
    this.purpose,
    this.comment,
    this.purposeRef,
    this.businessId,
    this.status,
    this.id,
  });

  @override
  String toString() {
    return 'AllTransaction(metaData: $metaData, profileRef: $profileRef, currentBalance: $currentBalance, amount: $amount, transactionType: $transactionType, purpose: $purpose, comment: $comment, purposeRef: $purposeRef, businessId: $businessId, status: $status, id: $id)';
  }

  factory AllTransaction.fromMap(Map<String, dynamic> data) {
    return AllTransaction(
      metaData: data['metaData'] == null
          ? null
          : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
      profileRef: data['profileRef'] == null
          ? null
          : Ref.fromMap(data['profileRef'] as Map<String, dynamic>),
      currentBalance: data['currentBalance'] as double?,
      amount: data['amount'] as double?,
      transactionType: data['transactionType'] as String?,
      purpose: data['purpose'] as String?,
      comment: data['comment'] as String?,
      purposeRef: data['purposeRef'] == null
          ? null
          : Ref.fromMap(data['purposeRef'] as Map<String, dynamic>),
      businessId: data['businessId'] as String?,
      status: data['status'] as String?,
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'profileRef': profileRef?.toMap(),
        'currentBalance': currentBalance,
        'amount': amount,
        'transactionType': transactionType,
        'purpose': purpose,
        'comment': comment,
        'purposeRef': purposeRef?.toMap(),
        'businessId': businessId,
        'status': status,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AllTransaction].
  factory AllTransaction.fromJson(String data) {
    return AllTransaction.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AllTransaction] to a JSON string.
  String toJson() => json.encode(toMap());

  AllTransaction copyWith({
    MetaData? metaData,
    Ref? profileRef,
    double? currentBalance,
    double? amount,
    String? transactionType,
    String? purpose,
    String? comment,
    Ref? purposeRef,
    String? businessId,
    String? status,
    String? id,
  }) {
    return AllTransaction(
      metaData: metaData ?? this.metaData,
      profileRef: profileRef ?? this.profileRef,
      currentBalance: currentBalance ?? this.currentBalance,
      amount: amount ?? this.amount,
      transactionType: transactionType ?? this.transactionType,
      purpose: purpose ?? this.purpose,
      comment: comment ?? this.comment,
      purposeRef: purposeRef ?? this.purposeRef,
      businessId: businessId ?? this.businessId,
      status: status ?? this.status,
      id: id ?? this.id,
    );
  }
}
