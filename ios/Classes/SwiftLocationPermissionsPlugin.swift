import Flutter
import UIKit
import CoreLocation

public class SwiftLocationPermissionsPlugin: NSObject, FlutterStreamHandler {
    
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    fileprivate var globalResult: FlutterResult?
    private var _eventSink: FlutterEventSink?
    private var _streamLocationAccuracyService: StreamLocationAccuracyAuthorizationService?
    private static let EVENT_CHANNEL_NAME = "location_permissions/events"
    
    static public func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "location_permissions", binaryMessenger: registrar.messenger())
        let eventsChannel = FlutterEventChannel(name: EVENT_CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftLocationPermissionsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        eventsChannel.setStreamHandler(instance)
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.globalResult = nil
    }
    
    func requestLocation(_ call: FlutterMethodCall) {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func accuracyAuthorization(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if #available(iOS 14.0, *) {
            let accuracyAuthorization = locationManager.accuracyAuthorization
            switch accuracyAuthorization {
            case .fullAccuracy:
                result(PermissionAccuracyStatus.fullAccuracy.rawValue)
                break
            case .reducedAccuracy:
                locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "ExampleUsageDescription")
                result(PermissionAccuracyStatus.reducedAccuracy.rawValue)
                break
            default:
                result(PermissionAccuracyStatus.reducedAccuracy.rawValue)
            }
        } else {
            // Fallback on earlier versions
            result(PermissionAccuracyStatus.notAvailable.rawValue)
        }
        
    }
    
    func locationAuthorization(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if #available(iOS 14.0, *) {
            let status = locationManager.authorizationStatus
            switch status {
            case .authorizedAlways:
                result(PermissionAuthorizationStatus.always.rawValue)
                break
            case .authorizedWhenInUse:
                result(PermissionAuthorizationStatus.whenInUse.rawValue)
                break
            case .denied:
                result(PermissionAuthorizationStatus.denied.rawValue)
                break
            case .notDetermined:
                result(PermissionAuthorizationStatus.notDetermined.rawValue)
                break
            case .restricted:
                result(PermissionAuthorizationStatus.restricted.rawValue)
                break
            default:
                break
            }
        } else {
            // Fallback on earlier versions
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .authorizedAlways:
                result(PermissionAuthorizationStatus.always.rawValue)
            case .authorizedWhenInUse:
                result(PermissionAuthorizationStatus.whenInUse.rawValue)
            case .denied:
                result(PermissionAuthorizationStatus.denied.rawValue)
            case .notDetermined:
                result(PermissionAuthorizationStatus.notDetermined.rawValue)
            case .restricted:
                result(PermissionAuthorizationStatus.restricted.rawValue)
            default:
                break
            }
        }
        
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if _streamLocationAccuracyService != nil {
            return FlutterError.init(
                code: "ALLREADY_LISTENING",
                message: "You are already listening for location accuracy changes. Create a new instance or stop listening to the current stream.",
                details: nil)
        }
        _streamLocationAccuracyService = StreamLocationAccuracyAuthorizationService.init(resultHandler: events);
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        //TODO
        return nil
    }
    
}

extension SwiftLocationPermissionsPlugin: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("[CLLocationManager] DEPRECATED didChangeAuthorization")
        if let globalResult = self.globalResult {
            switch status {
            case .authorizedAlways:
                globalResult(PermissionAuthorizationStatus.always.rawValue)
            case .authorizedWhenInUse:
                globalResult(PermissionAuthorizationStatus.whenInUse.rawValue)
            case .denied:
                globalResult(PermissionAuthorizationStatus.denied.rawValue)
            case .notDetermined:
                globalResult(PermissionAuthorizationStatus.notDetermined.rawValue)
            case .restricted:
                globalResult(PermissionAuthorizationStatus.restricted.rawValue)
            default:
                break
            }
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("[CLLocationManager] didChangeAuthorization")
        if let globalResult = self.globalResult {
            if #available(iOS 14.0, *) {
                let status = manager.authorizationStatus
                switch status {
                case .authorizedAlways:
                    globalResult(PermissionAuthorizationStatus.always.rawValue)
                    break
                case .authorizedWhenInUse:
                    globalResult(PermissionAuthorizationStatus.whenInUse.rawValue)
                    break
                case .denied:
                    globalResult(PermissionAuthorizationStatus.denied.rawValue)
                    break
                case .notDetermined:
                    globalResult(PermissionAuthorizationStatus.notDetermined.rawValue)
                    break
                case .restricted:
                    globalResult(PermissionAuthorizationStatus.restricted.rawValue)
                    break
                default:
                    break
                }
            } else {
                // Fallback on earlier versions
                let status = CLLocationManager.authorizationStatus()
                print("[CLLocationManager] status: \(status.rawValue)")
                switch status {
                case .authorizedAlways:
                    globalResult(PermissionAuthorizationStatus.always.rawValue)
                case .authorizedWhenInUse:
                    globalResult(PermissionAuthorizationStatus.whenInUse.rawValue)
                case .denied:
                    globalResult(PermissionAuthorizationStatus.denied.rawValue)
                case .notDetermined:
                    globalResult(PermissionAuthorizationStatus.notDetermined.rawValue)
                case .restricted:
                    globalResult(PermissionAuthorizationStatus.restricted.rawValue)
                default:
                    break
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
}

extension SwiftLocationPermissionsPlugin: FlutterPlugin {
    private enum MethodChannel: String {
        case requestLocation
        case accuracyAuthorization
        case authorizationStatus
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = MethodChannel(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
        switch method {
        case .requestLocation:
            globalResult = result
            requestLocation(call)
            break;
        case .accuracyAuthorization:
            accuracyAuthorization(call, result: result)
        case .authorizationStatus:
            locationAuthorization(call, result: result)
        }
    }
}
