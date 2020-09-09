import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_permissions/location_permissions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _authorizationStatus = 'Unknown';
  String _accuracyStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await LocationPermissions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
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
                await LocationPermissions.requestLocation();
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
              child: Text('Running on: $_platformVersion\n'),
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
