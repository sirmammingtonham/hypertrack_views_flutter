package com.yeeb.hypertrack_views_flutter

import com.hypertrack.sdk.views.dao.MovementStatus
import com.hypertrack.sdk.views.dao.Trip

fun Trip.toMap(): HashMap<String, Any?> {
    return hashMapOf(
            "trip_id" to this.tripId,
            "status" to this.status,
            "startedAt" to this.startedAt,
            "metadata" to this.metadata,
            "summary" to this.summary,
            "destination.address" to this.destination?.address,
            "destination.radius" to this.destination?.radius,
            "destination.latitude" to this.destination?.latitude,
            "destination.longitude" to this.destination?.longitude,
            "destination.arrivedAt" to this.destination?.arrivedAt,
            "destination.exitedAt" to this.destination?.exitedAt,
            "destination.scheduledAt" to this.destination?.scheduledAt
    )
}

fun MovementStatus.toMap(): HashMap<String, Any?> {
    return hashMapOf(
            "device_id" to this.deviceId,

            "device_info.app_version_number" to  this.deviceInfo?.appVersionNumber,
            "device_info.app_version_string" to this.deviceInfo?.appVersionString,
            "device_info.device_brand" to this.deviceInfo?.deviceBrand,
            "device_info.device_model" to this.deviceInfo?.deviceModel,
            "device_info.name" to this.deviceInfo?.name,
            "device_info.os_name" to this.deviceInfo?.osName,
            "device_info.os_version" to this.deviceInfo?.osVersion,
            "device_info.sdk_version" to this.deviceInfo?.sdkVersion,
            "device_info.battery" to this.battery,

            "device_status.createdAt" to this.deviceStatus?.createdAt,
            "device_status.status" to this.deviceStatus?.status,

            "location.accuracy" to this.location?.accuracy,
            "location.altitude" to this.location?.altitude,
            "location.bearing" to this.location?.bearing,
            "location.speed" to this.location?.speed,
            "location.latitude" to this.location?.latitude,
            "location.longitude" to this.location?.longitude,
            "location.recordedAt" to this.location?.recordedAt,

            "trips" to this.trips.map { it.toMap() }
    )
}