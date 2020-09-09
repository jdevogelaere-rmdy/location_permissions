import Flutter
import UIKit
import CoreLocation

public class SwiftLocationPermissionsPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager = CLLocationManager()
    private var globalResult: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "location_permissions", binaryMessenger: registrar.messenger())
        let instance = SwiftLocationPermissionsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.globalResult = nil
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "requestLocation":
            globalResult = result
            requestLocation(call)
            break;
        case "getAccuracyAuthorization":
            accuracyAuthorization(call, result: result)
        case "getAuthorizationStatus":
            locationAuthorization(call, result: result)
        default:
            result("iOS " + UIDevice.current.systemVersion)
        }
    }
    
    func requestLocation(_ call: FlutterMethodCall) {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if let globalResult = self.globalResult {
            if #available(iOS 14.0, *) {
                let status = manager.authorizationStatus
                switch status {
                case .authorizedAlways:
                    globalResult("authorizedAlways")
                    break
                case .authorizedWhenInUse:
                    globalResult("authorizedWhenInUse")
                    break
                case .denied:
                    globalResult("denied")
                    break
                case .notDetermined:
                    globalResult("notDetermined")
                    break
                case .restricted:
                    globalResult("restricted")
                    break
                default:
                    break
                }
            } else {
                // Fallback on earlier versions
                let status = CLLocationManager.authorizationStatus()
                switch status {
                case .authorizedAlways:
                    globalResult("authorizedAlways")
                case .authorizedWhenInUse:
                    globalResult("authorizedWhenInUse")
                case .denied:
                    globalResult("denied")
                case .notDetermined:
                    globalResult("notDetermined")
                case .restricted:
                    globalResult("restricted")
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    func accuracyAuthorization(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if #available(iOS 14.0, *) {
            let accuracyAuthorization = locationManager.accuracyAuthorization
            switch accuracyAuthorization {
            case .fullAccuracy:
                result("fullAccuracy")
                break
            case .reducedAccuracy:
                locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "ExampleUsageDescription")
                result("reducedAccuracy")
                break
            default:
                break
            }
        } else {
            // Fallback on earlier versions
            result("No accuracy status on earlier versions")
        }
        
    }
    
    func locationAuthorization(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if #available(iOS 14.0, *) {
            let status = locationManager.authorizationStatus
            switch status {
            case .authorizedAlways:
                result("authorizedAlways")
                break
            case .authorizedWhenInUse:
                result("authorizedWhenInUse")
                break
            case .denied:
                result("denied")
                break
            case .notDetermined:
                result("notDetermined")
                break
            case .restricted:
                result("restricted")
                break
            default:
                break
            }
        } else {
            // Fallback on earlier versions
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .authorizedAlways:
                result("authorizedAlways")
            case .authorizedWhenInUse:
                result("authorizedWhenInUse")
            case .denied:
                result("denied")
            case .notDetermined:
                result("notDetermined")
            case .restricted:
                result("restricted")
            }
        }
        
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
}
