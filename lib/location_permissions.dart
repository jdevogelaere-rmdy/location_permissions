import 'dart:async';

import 'package:flutter/services.dart';

class LocationPermissions {
  static const MethodChannel _channel =
      const MethodChannel('location_permissions');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get authorizationStatus async {
    final String authorizationStatus =
        await _channel.invokeMethod('getAuthorizationStatus');

    return authorizationStatus;
  }

  static Future<String> get accuracyStatus async {
    final String accuracyStatus =
        await _channel.invokeMethod('getAccuracyAuthorization');

    return accuracyStatus;
  }

  static Future<void> requestLocation() async {
    return await _channel.invokeMethod('requestLocation');
  }
}
