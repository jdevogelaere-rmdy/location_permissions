//
//  LocationServices.swift
//  location_permissions
//
//  Created by Jordan de Vogelaere on 06/10/2020.
//

import CoreLocation
import Flutter
import Foundation

protocol LocationServiceProtocol : CLLocationManagerDelegate {}

class LocationService : NSObject, LocationServiceProtocol {
    typealias ResultHandler = (_ result: Any) -> ()
    
    private var _locationManager: CLLocationManager?
    var _resultHandler: ResultHandler?
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    
    init(resultHandler: @escaping ResultHandler) {
        super.init()

        self._resultHandler = resultHandler
        locationManager.delegate = self
    }
    
}

final class StreamLocationAccuracyAuthorizationService : LocationService {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let resultHandler = self._resultHandler else {
            return
        }
        if #available(iOS 14.0, *) {
            let accuracyStatus = manager.accuracyAuthorization
            let status = locationManager.authorizationStatus
            switch status {
            case .authorizedAlways:
                let dict = ["AuthorizationStatus": PermissionAuthorizationStatus.always.rawValue, "AccuracyStatus": accuracyStatus.rawValue]
                resultHandler(dict)
                break
            case .authorizedWhenInUse:
                let dict = ["AuthorizationStatus": PermissionAuthorizationStatus.whenInUse.rawValue, "AccuracyStatus": accuracyStatus.rawValue]
                resultHandler(dict)
                break
            case .denied:
                let dict = ["AuthorizationStatus": PermissionAuthorizationStatus.denied.rawValue, "AccuracyStatus": accuracyStatus.rawValue]
                resultHandler(dict)
                break
            case .notDetermined:
                let dict = ["AuthorizationStatus": PermissionAuthorizationStatus.notDetermined.rawValue, "AccuracyStatus": accuracyStatus.rawValue]
                resultHandler(dict)
                break
            case .restricted:
                let dict = ["AuthorizationStatus": PermissionAuthorizationStatus.restricted.rawValue, "AccuracyStatus": accuracyStatus.rawValue]
                resultHandler(dict)
                break
            default:
                break
            }
        } else {
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .authorizedAlways:
                let dict = ["AuthorizationStatus": PermissionAuthorizationStatus.always.rawValue, "AccuracyStatus": 0]
                resultHandler(dict)
            case .authorizedWhenInUse:
                let dict = ["AuthorizationStatus": PermissionAuthorizationStatus.whenInUse.rawValue, "AccuracyStatus": 0]
                resultHandler(dict)
            case .denied:
                let dict = ["AuthorizationStatus": PermissionAuthorizationStatus.denied.rawValue, "AccuracyStatus": 0]
                resultHandler(dict)
            case .notDetermined:
                let dict = ["AuthorizationStatus": PermissionAuthorizationStatus.notDetermined.rawValue, "AccuracyStatus": 0]
                resultHandler(dict)
            case .restricted:
                let dict = ["AuthorizationStatus": PermissionAuthorizationStatus.restricted.rawValue, "AccuracyStatus": 0]
                resultHandler(dict)
            default:
                break
            }
        }
        
    }
}
