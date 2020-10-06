enum AuthorizationStatus {
  always,
  whenInUse,
  denied,
  notDetermined,
  restricted
}

enum AccuracyStatus { fullAccuracy, reducedAccuracy, notAvailable }

class LocationPermissionStatus {
  final AuthorizationStatus authorizationStatus;
  final AccuracyStatus accuracyStatus;

  const LocationPermissionStatus(
      {this.authorizationStatus, this.accuracyStatus});
}
