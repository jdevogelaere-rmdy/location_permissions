import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthorizationStatus _authorizationStatus = AuthorizationStatus.notDetermined;
  AccuracyStatus _accuracyStatus = AccuracyStatus.notAvailable;
  StreamSubscription<LocationPermissionStatus> _accuracyStatusSubscription;

  @override
  void initState() {
    super.initState();

    _accuracyStatusSubscription = LocationPermissions()
        .getAuthorizationStatus()
        .listen((LocationPermissionStatus status) {
      setState(() {
        _accuracyStatus = status.accuracyStatus;
        _authorizationStatus = status.authorizationStatus;
      });
    });
  }

  @override
  void dispose() {
    if (_accuracyStatusSubscription != null) {
      _accuracyStatusSubscription.cancel();
      _accuracyStatusSubscription = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            MaterialButton(
              onPressed: () async {
                await LocationPermissions
                    .requestLocationAuthorizationWithPurposeKey(
                        "ExampleUsageDescription");
                final authorizationStatus =
                    await LocationPermissions.authorizationStatus;
                final accuracyStatus = await LocationPermissions.accuracyStatus;
                setState(() {
                  _accuracyStatus = accuracyStatus;
                  _authorizationStatus = authorizationStatus;
                });
              },
              child: Text('Request Location'),
            ),
            Center(
              child: Text('AuhtorizationStatus: $_authorizationStatus\n'),
            ),
            Center(
              child: Text('AccuracyStatus: $_accuracyStatus\n'),
            ),
          ],
        ),
      ),
    );
  }
}
