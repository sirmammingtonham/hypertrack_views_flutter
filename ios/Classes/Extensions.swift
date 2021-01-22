//
//  Extensions.swift
//  ViewsExample
//
//  Created by Ethan on 1/21/21.
//

import Foundation
import HyperTrackViews

extension MovementStatus.Trip {
    func toJSON() -> NSDictionary {
        return [
            "trip_id": self.id,
            "status": NSNull(),
            "metadata": self.metadata,
            "summary": self.summary,
            "destination": self.destination != nil ?
                [
                    "radius": NSNumber(floatLiteral: self.destination!.radius),
                    "address": self.destination!.address,
                    "geometry": [
                        "coordinates": [
                            NSNumber(floatLiteral: self.destination!.coordinate.longitude),
                            NSNumber(floatLiteral: self.destination!.coordinate.latitude)
                        ],
                        "type": "Point",
                    ],
                ]
                : NSNull(),
            "views": ["embed_url": self.views.embedURL, "share_url": self.views.shareURL]
        ];
    }
}

extension MovementStatus.Device.Android {
    func toJSON(deviceName: String) -> NSDictionary {
        return [
            "app_version_number": self.app.versionCode != nil ? self.app.versionCode : NSNull(),
            "app_version_string": self.app.version,
            "device_brand": self.hardware.brand,
            "device_model": self.hardware.model,
            "name": deviceName,
            "os_name": "Android",
            "os_version": self.version,
            "sdk_version": self.sdk.version,
        ]
    }
}

extension MovementStatus.Device.iOS {
    func toJSON(deviceName: String) -> NSDictionary {
        return [
            "app_version_number": NSNull(),
            "app_version_string": self.app.version,
            "device_brand": "Apple",
            "device_model": self.hardware.model,
            "name": deviceName,
            "os_name": "iOS",
            "os_version": self.version,
            "sdk_version": self.sdk.version,
        ]
    }
}

extension MovementStatus {
    func toJSON() -> NSDictionary {
        return [
            "device_id": self.device.id,
            "device_info": NSNull(), // don't know how to or why you cant access anything from Device.OS
            "device_status": [
                "createdAt": self.status.timestamp,
                "status": self.status.type, // enum pls cast
            ],
            "location": [
                "geometry": [
                    "coordinates":[self.location.coordinate.longitude, self.location.coordinate.latitude],
                    "type": "Point",
                ],
                "altitude": self.location.altitude,
                "speed": self.location.speed,
                "bearing": self.location.course,
                "accuracy": self.location.horizontalAccuracy,
            ],
            "trips": self.trips.map { (trip) -> NSDictionary in
                trip.toJSON()
            },
        ]
    }
}

//[
//    "app_version_number": self.device.os,
//    "app_version_string": self.device.os,
//    "device_brand": self.device.os,
//    "device_model": self.device.os,
//    "name": self.device.name,
//    "os_name": self.device.os,
//    "os_version": self.device.os,
//    "sdk_version": self.device.os,
//]
