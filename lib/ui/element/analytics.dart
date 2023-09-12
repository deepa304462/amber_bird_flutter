import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelManager {
  static Mixpanel? _instance;

  static Future<Mixpanel> init() async {
    if (_instance == null) {
      _instance = await Mixpanel.init("6d970ba07d8d32bad8ce1d316c30c22c",
          optOutTrackingDefault: false, trackAutomaticEvents: true);
    }
    return _instance!;
  }
}
