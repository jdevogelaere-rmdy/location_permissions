//
//  Location.swift
//  location_permissions
//
//  Created by Jordan de Vogelaere on 09/09/2020.
//

import Foundation

enum AuthorizationStatus: Int{
    case always
    case whenInUse
    case denied
    case notDetermined
    case restricted
}

enum AccuracyStatus {
    case fullAccuracy
    case reducedAccuracy
    case notAvailable
}
