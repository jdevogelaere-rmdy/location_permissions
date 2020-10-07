import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:location_permissions/src/location_enums.dart';

class LocationPermissions {
  static const MethodChannel _channel =
      const MethodChannel('location_permissions');

  static Future<AuthorizationStatus> get authorizationStatus async {
    if (Platform.isIOS) {
      final int authorizationStatus =
          await _channel.invokeMethod('authorizationStatus');

      return AuthorizationStatus.values[authorizationStatus];
    } else {
      final int status =
          await _channel.invokeMethod('checkPermissionStatus', 0);

      final permissionStatus = PermissionStatus.values[status];

      return permissionStatus == PermissionStatus.granted
          ? AuthorizationStatus.always
          : AuthorizationStatus.denied;
    }
  }

  static Future<AccuracyStatus> get accuracyStatus async {
    if (Platform.isIOS) {
      final int accuracyStatus =
          await _channel.invokeMethod('accuracyAuthorization');

      return AccuracyStatus.values[accuracyStatus];
    } else {
      return AccuracyStatus.fullAccuracy;
    }
  }

  static Future<void> requestLocationAuthorizationWithPurposeKey(
      String purposeKey) async {
    if (Platform.isIOS) {
      return await _channel.invokeMethod('requestLocation', purposeKey);
    } else {
      return await _channel.invokeMethod('requestPermission', 0);
    }
  }

  Stream<LocationPermissionStatus> getAuthorizationStatus() {
    if (Platform.isIOS) {
      return EventChannel('location_permissions/events')
          .receiveBroadcastStream()
          .map((event) {
        final authorizationStatus = event["AuthorizationStatus"];
        final accuracyStatus = event["AccuracyStatus"];
        final accuracy = AccuracyStatus.values[accuracyStatus];
        final authorization = AuthorizationStatus.values[authorizationStatus];
        return LocationPermissionStatus(
            authorizationStatus: authorization, accuracyStatus: accuracy);
      });
    } else {
      assert(Platform.isAndroid,
          'Listening to service state changes is only supported on Android.');

      /*return EventChannel('location_permissions/events')
          .receiveBroadcastStream()
          .map((dynamic status) =>
              status ? ServiceStatus.enabled : ServiceStatus.disabled);*/
    }
  }
}
