import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum OSInFocusDisplayOption { InAppAlert, Notification, None }

class FlutterOneSignal {
  static MethodChannel _channel = MethodChannel('flutter_one_signal/methods');
  static final EventChannel eventChannel =
      EventChannel('flutter_one_signal/events');

  static startInit({
    @required String appId,
    OSInFocusDisplayOption inFocusDisplaying =
        OSInFocusDisplayOption.InAppAlert,
    bool unsubscribeWhenNotificationsAreDisabled = false,
    void notificationReceivedHandler(dynamic notification),
    void notificationOpenedHandler(dynamic notification),
  }) {
    _channel.invokeMethod('startInit', {
      'appId': appId,
      'inFocusDisplaying': inFocusDisplaying.toString(),
      'unsubscribeWhenNotificationsAreDisabled':
          unsubscribeWhenNotificationsAreDisabled.toString()
    });

    eventChannel.receiveBroadcastStream().listen((data) {
      var input = data as String;
      print(input);
      if (input.startsWith('opened:') && notificationOpenedHandler != null) {
        notificationOpenedHandler(input.substring(7, input.length));
      } else if (input.startsWith('received:') &&
          notificationReceivedHandler != null) {
        notificationReceivedHandler(input.substring(9, input.length));
      }
    });
  }

  static setTag(String key, String value) {
    _channel.invokeMethod('setTag', {
      'key': key,
      'value': value,
    });
  }
}
