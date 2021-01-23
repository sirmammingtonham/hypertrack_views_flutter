//
//  toMapExtensions.swift
//  hypertrack_views_flutter
//
//  Created by Ethan on 1/21/21.
//

import Foundation
import HyperTrackViews

extension MovementStatus.Trip {
    func toMap() -> [String: Any?] {
        var arriveAt: Any?
        var polyline: Any?
        switch destination?.estimate {
        case let .relevant(route):
            arriveAt = route.duration.description
            polyline = route.polyline.map {
                (coordinate) -> [Double] in
                [coordinate.latitude, coordinate.longitude]
            }
        default:
            break
        }
        return [
            "trip_id": id,
            "startedAt": startedAt.description,
            "metadata": metadata,
            "summary": summary,
            "embedURL": views.embedURL.absoluteString,
            "shareURL": views.shareURL.absoluteString,

            "destination.address": destination?.address,
            "destination.radius": destination?.radius,
            "destination.latitude": destination?.coordinate.latitude,
            "destination.longitude": destination?.coordinate.longitude,
            "destination.arrivedAt": destination?.arrivedAt?.description,
            "destination.exitedAt": destination?.exitedAt?.description,
            "destination.scheduledAt": destination?.scheduledAt?.description,

            "estimate.arriveAt": arriveAt,
            "estimate.route": polyline,
        ]
    }
}

extension MovementStatus {
    func toMap() -> [String: Any?] {
        var batteryState: Int
        var statusState: Int
        switch battery {
        case .low:
            batteryState = 0
        case .normal:
            batteryState = 1
        case .charging:
            batteryState = 2
        default:
            batteryState = -1
        }
        switch status.type {
        case .active:
            statusState = 0
        case .disconnected:
            statusState = 1
        case .inactive:
            statusState = 2
        default:
            statusState = -1
        }
        var movementStatus: [String: Any?] = [
            "device_id": device.id,

            "device_info.name": device.name,
            "device_info.battery": batteryState,

            "device_status.createdAt": status.timestamp.description,
            "device_status.status": statusState,

            "location.accuracy": location.horizontalAccuracy,
            "location.altitude": location.altitude,
            "location.bearing": location.course,
            "location.speed": location.speed,
            "location.latitude": location.coordinate.latitude,
            "location.longitude": location.coordinate.longitude,
            "location.recordedAt": location.timestamp.description,

            "trips": trips.map { (trip) -> [String: Any?] in
                trip.toMap()
            },
        ]
        switch device.os {
        case let .Android(os):
            movementStatus["device_info.app_version_number"] = os.app.versionCode
            movementStatus["device_info.app_version_string"] = os.app.version
            movementStatus["device_info.device_brand"] = os.hardware.brand
            movementStatus["device_info.device_model"] = os.hardware.model
            movementStatus["device_info.os_name"] = "Android"
            movementStatus["device_info.os_version"] = os.version
            movementStatus["device_info.sdk_version"] = os.sdk.version
        case let .iOS(os):
            movementStatus["device_info.app_version_number"] = os.app.id
            movementStatus["device_info.app_version_string"] = os.app.version
            movementStatus["device_info.device_brand"] = "Apple"
            movementStatus["device_info.device_model"] = os.hardware.model
            movementStatus["device_info.os_name"] = "iOS"
            movementStatus["device_info.os_version"] = os.version
            movementStatus["device_info.sdk_version"] = os.sdk.version
        }

        return movementStatus
    }
}
