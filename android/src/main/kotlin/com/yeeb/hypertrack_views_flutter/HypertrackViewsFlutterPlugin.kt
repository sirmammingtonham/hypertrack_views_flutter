package com.yeeb.hypertrack_views_flutter

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import app.loup.streams_channel.StreamsChannel
import io.flutter.plugin.common.EventChannel


import com.google.gson.Gson
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
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "initialize" -> {
                Log.d("HypertrackViewsAndroid", "Initializing")
                if (call.arguments != null) {
                    mHyperTrackView = HyperTrackViews.getInstance(context, call.arguments as String)
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
                { result.success(Gson().toJson(it as MovementStatus)) }

            }
            "stopAllUpdates" -> mHyperTrackView.stopAllUpdates()
            else -> result.notImplemented()
        }
    }


    // Listeners
    private fun startListening(deviceId: String, emitter: EventChannel.EventSink) {
        mHyperTrackView.subscribeToDeviceUpdates(deviceId,
                object : DeviceUpdatesHandler {
                    private val args: HashMap<String, Any> = HashMap()

                    override fun onLocationUpdateReceived(location: Location) {
                        args["deviceId"] = deviceId
                        args["location"] = Gson().toJson(location)
                        emitter.success(args)
                    }

                    override fun onBatteryStateUpdateReceived(@MovementStatus.BatteryState i: Int) {
                        args["deviceId"] = deviceId
                        args["batteryState"] = i
                        emitter.success(args)
                    }

                    override fun onStatusUpdateReceived(statusUpdate: StatusUpdate) {
                        args["deviceId"] = deviceId
                        args["statusUpdate"] = Gson().toJson(statusUpdate)
                        emitter.success(args)
                    }

                    override fun onTripUpdateReceived(trip: Trip) {
                        args["deviceId"] = deviceId
                        args["trip"] = Gson().toJson(trip)
                        emitter.success(args)
                    }

                    override fun onError(exception: Exception, deviceId: String) {
                        args["deviceId"] = deviceId
                        args["exception"] = Gson().toJson(exception)
                        emitter.success(args)
                    }

                    override fun onCompleted(deviceId: String) {
                        args["deviceId"] = deviceId
                        args["completed"] = true
                        emitter.success(args)
                    }
                }
        )
    }

    private fun cancelListening(deviceId: String) {
        mHyperTrackView.unsubscribeFromDeviceUpdates(deviceId)
    }
}
