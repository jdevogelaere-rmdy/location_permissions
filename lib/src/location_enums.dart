enum AuthorizationStatus {
  always,
  whenInUse,
  denied,
  notDetermined,
  restricted
}

enum AccuracyStatus { fullAccuracy, reducedAccuracy, notAvailable }

enum PermissionStatus {
  unknown,
  denied,
  granted,
  restricted,
}

class LocationPermissionStatus {
  final AuthorizationStatus authorizationStatus;
  final AccuracyStatus accuracyStatus;

  const LocationPermissionStatus(
      {this.authorizationStatus, this.accuracyStatus});
}
