//
//  Location.swift
//  location_permissions
//
//  Created by Jordan de Vogelaere on 09/09/2020.
//

import Foundation

enum PermissionAuthorizationStatus: Int {
    case always = 0
    case whenInUse
    case denied
    case notDetermined
    case restricted
}

enum PermissionAccuracyStatus: Int {
    case fullAccuracy = 0
    case reducedAccuracy
    case notAvailable
}
