import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  static init() async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics
        .setDefaultEventParameters({'version': '0.0.1'});
  }

  static logEvent(name, parameters) async {
    await analytics.logEvent(
      name: name,
      parameters: parameters,
    );
    // await analytics.logEvent(
    //   name: 'test_event',
    //   parameters: <String, dynamic>{
    //     'string': 'string',
    //     'int': 42,
    //     'long': 12345678910,
    //     'double': 42.0,
    //     // Only strings and numbers (ints & doubles) are supported for GA custom event parameters:
    //     // https://developers.google.com/analytics/devguides/collection/analyticsjs/custom-dims-mets#overview
    //     'bool': true.toString(),
    //   },
    // );
   }

  Future<void> setUserId(id) async {
    await analytics.setUserId(id: id);
   }
}
