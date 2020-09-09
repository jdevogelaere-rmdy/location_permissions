import 'dart:async';

import 'package:flutter/services.dart';
import 'package:location_permissions/src/location_enums.dart';

class LocationPermissions {
  static const MethodChannel _channel =
      const MethodChannel('location_permissions');

  static Future<AuthorizationStatus> get authorizationStatus async {
    final int authorizationStatus =
        await _channel.invokeMethod('authorizationStatus');

    return AuthorizationStatus.values[authorizationStatus];
  }

  static Future<AccuracyStatus> get accuracyStatus async {
    final int accuracyStatus =
        await _channel.invokeMethod('accuracyAuthorization');

    return AccuracyStatus.values[accuracyStatus];
  }

  static Future<void> requestLocation() async {
    return await _channel.invokeMethod('requestLocation');
  }
}