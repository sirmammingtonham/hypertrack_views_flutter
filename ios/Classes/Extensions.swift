//
//  Extensions.swift
//  ViewsExample
//
//  Created by Ethan on 1/21/21.
//

import Foundation
import HyperTrackViews

extension MovementStatus.Trip {
    func toJSON() -> Dictionary<String, AnyObject> {
        let destinationDict: Dictionary<String, AnyObject>?
        if self.destination != nil {
            destinationDict = [
                "radius": Double(self.destination!.radius) as AnyObject,
                "address": self.destination!.address as AnyObject,
                "geometry": [
                    "coordinates": [
                        Double(self.destination!.coordinate.longitude),
                        Double(self.destination!.coordinate.latitude)
                    ] as AnyObject,
                    "type": "Point" as AnyObject,
                ] as AnyObject,
            ]
        } else {
            destinationDict = nil
        }
        return [
            "trip_id": self.id as AnyObject,
            "status": NSNull() as AnyObject,
            "metadata": self.metadata as AnyObject,
            "summary": self.summary as AnyObject,
            "destination": destinationDict != nil ? destinationDict as AnyObject : NSNull() as AnyObject,
            "views": ["embed_url": self.views.embedURL, "share_url": self.views.shareURL] as AnyObject
        ];
    }
}

extension MovementStatus.Device.Android {
    func toJSON(deviceName: String) -> Dictionary<String, AnyObject> {
        return [
            "app_version_number": self.app.versionCode != nil ? self.app.versionCode as AnyObject : NSNull() as AnyObject,
            "app_version_string": self.app.version as AnyObject,
            "device_brand": self.hardware.brand as AnyObject,
            "device_model": self.hardware.model as AnyObject,
            "name": deviceName as AnyObject,
            "os_name": "Android" as AnyObject,
            "os_version": self.version as AnyObject,
            "sdk_version": self.sdk.version as AnyObject,
        ]
    }
}

extension MovementStatus.Device.iOS {
    func toJSON(deviceName: String) -> Dictionary<String, AnyObject> {
        return [
            "app_version_number": NSNull() as AnyObject,
            "app_version_string": self.app.version as AnyObject,
            "device_brand": "Apple" as AnyObject,
            "device_model": self.hardware.model as AnyObject,
            "name": deviceName as AnyObject,
            "os_name": "iOS" as AnyObject,
            "os_version": self.version as AnyObject,
            "sdk_version": self.sdk.version as AnyObject,
        ]
    }
}

extension MovementStatus {
    func toJSON() -> Dictionary<String, AnyObject> {
        return [
            "device_id": self.device.id as AnyObject,
            "device_info": NSNull() as AnyObject, // don't know how to or why you cant access anything from Device.OS
            "device_status": [
                "createdAt": self.status.timestamp,
                "status": self.status.type, // enum pls cast
            ] as AnyObject,
            "location": [
                "geometry": [
                    "coordinates":[self.location.coordinate.longitude, self.location.coordinate.latitude],
                    "type": "Point",
                ] as AnyObject,
                "altitude": self.location.altitude as AnyObject,
                "speed": self.location.speed as AnyObject,
                "bearing": self.location.course as AnyObject,
                "accuracy": self.location.horizontalAccuracy as AnyObject,
            ] as AnyObject,
            "trips": self.trips.map { (trip) -> Dictionary<String, AnyObject?> in
                trip.toJSON()
            } as AnyObject,
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
