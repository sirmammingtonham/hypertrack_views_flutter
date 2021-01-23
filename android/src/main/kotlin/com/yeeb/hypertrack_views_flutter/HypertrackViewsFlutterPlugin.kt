package com.yeeb.hypertrack_views_flutter

import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import app.loup.streams_channel.StreamsChannel
import io.flutter.plugin.common.EventChannel

import com.hypertrack.sdk.views.DeviceUpdatesHandler
import com.hypertrack.sdk.views.HyperTrackViews
import com.hypertrack.sdk.views.dao.Location
import com.hypertrack.sdk.views.dao.MovementStatus
import com.hypertrack.sdk.views.dao.StatusUpdate
import com.hypertrack.sdk.views.dao.Trip


/** HypertrackViewsFlutterPlugin */
class HypertrackViewsFlutterPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: StreamsChannel
    private lateinit var mHyperTrackView: HyperTrackViews
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "hypertrack_views_flutter/methods")
        eventChannel = StreamsChannel(flutterPluginBinding.binaryMessenger, "hypertrack_views_flutter/events")

        methodChannel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "initialize" -> {
                if (call.arguments != null) {
                    mHyperTrackView = HyperTrackViews.getInstance(context, call.arguments as String)

                    eventChannel.setStreamHandlerFactory {
                        object : EventChannel.StreamHandler {
                            override fun onListen(arguments: Any, eventSink: EventChannel.EventSink) {
                                startListening(arguments as String, eventSink)
                            }

                            override fun onCancel(arguments: Any) {
                                cancelListening(arguments as String)
                            }
                        }
                    }

                    result.success(true)
                } else {
                    result.error("squabbit", "Invalid arguments", "Expected at least 1 arg")
                }
            }
            "getDeviceMovementStatus" -> {
                if (!this::mHyperTrackView.isInitialized) {
                    result.error("monke", "SDK not initialized!", "run initialize()")
                    return
                }
                if (call.arguments == null) {
                    result.error("squabbit", "Invalid arguments", "Expected at least 1 arg")
                    return
                }
                mHyperTrackView.getDeviceMovementStatus(call.arguments as String)
                {
                    if (it != null) {
                        result.success(it.toMap())
                    } else {
                        result.error("bruhmoment", "response was null", "good luck debugging")
                    }
                }

            }
            "stopAllUpdates" -> mHyperTrackView.stopAllUpdates()
            else -> result.notImplemented()
        }
    }


    // Listeners
    private fun startListening(deviceId: String, emitter: EventChannel.EventSink) {
        var movementStatus: HashMap<String, Any?> = hashMapOf()
        mHyperTrackView.getDeviceMovementStatus(deviceId)
        {
            if (it != null) {
                movementStatus = it.toMap()
                emitter.success(movementStatus)
            } else {
                emitter.error("bruhmoment", "response was null", "good luck debugging")
            }
        }

        mHyperTrackView.subscribeToDeviceUpdates(deviceId,
                object : DeviceUpdatesHandler {
                    override fun onLocationUpdateReceived(location: Location) {
                        movementStatus["location.accuracy"] = location.accuracy
                        movementStatus["location.altitude"] = location.altitude
                        movementStatus["location.bearing"] = location.bearing
                        movementStatus["location.speed"] = location.speed
                        movementStatus["location.latitude"] = location.latitude
                        movementStatus["location.longitude"] = location.longitude
                        movementStatus["location.recordedAt"] = location.recordedAt
                        emitter.success(movementStatus)
                    }

                    override fun onBatteryStateUpdateReceived(@MovementStatus.BatteryState i: Int) {
                        movementStatus["device_info.battery"] = i
                        emitter.success(movementStatus)
                    }

                    override fun onStatusUpdateReceived(statusUpdate: StatusUpdate) {
                        movementStatus["device_status.createdAt"] = statusUpdate.recordedAt
                        movementStatus["device_status.status"] = statusUpdate.value
                        emitter.success(movementStatus)
                    }

                    override fun onTripUpdateReceived(trip: Trip) {
                        @Suppress("UNCHECKED_CAST")
                        (movementStatus["trips"] as? MutableList<HashMap<String, Any?>>)?.add(trip.toMap())
                        emitter.success(movementStatus)
                    }

                    override fun onError(exception: Exception, deviceId: String) {
                        emitter.error("bruhmoment",
                                "Failed to get MovementStatus, ensure deviceId exists!",
                                exception.message
                        )
                    }

                    override fun onCompleted(deviceId: String) {
                        emitter.endOfStream()
                    }
                }
        )
    }

    private fun cancelListening(deviceId: String) {
        mHyperTrackView.unsubscribeFromDeviceUpdates(deviceId)
    }
}
