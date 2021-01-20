package com.yeeb.hypertrack_views_flutter

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.google.gson.Gson
import com.hypertrack.sdk.views.DeviceUpdatesHandler
import com.hypertrack.sdk.views.HyperTrackViews
import com.hypertrack.sdk.views.dao.Location
import com.hypertrack.sdk.views.dao.MovementStatus
import com.hypertrack.sdk.views.dao.StatusUpdate
import com.hypertrack.sdk.views.dao.Trip

/** HypertrackViewsFlutterPlugin */
class HypertrackViewsFlutterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var mHyperTrackView : HyperTrackViews
  private lateinit var context : Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "hypertrack_views_flutter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "initialize" -> {
        Log.d("HypertrackViewsAndroid", "Initializing")
        if (call.arguments != null) {
          mHyperTrackView = HyperTrackViews.getInstance(context, call.arguments as String)
          result.success(true)
          // channel.invokeMethod("print", "initialized")
        }
      }
      "getDeviceMovementStatus" -> {
        if (checkErrors(call, result)) {
          mHyperTrackView.getDeviceMovementStatus(call.arguments as String)
          {result.success(Gson().toJson(it as MovementStatus))}
        }
      }
      "subscribeToDeviceUpdates" -> {
        if (checkErrors(call, result)) {
          val deviceId = call.arguments as String
          mHyperTrackView.subscribeToDeviceUpdates(deviceId,
                  object : DeviceUpdatesHandler {
                    override fun onLocationUpdateReceived(location: Location) {
                      val args: HashMap<String, Any> = HashMap()
                      args["deviceId"] = deviceId
                      args["location"] = Gson().toJson(location)
                      channel.invokeMethod("onLocationUpdateReceived", args)
                    }
                    override fun onBatteryStateUpdateReceived(@MovementStatus.BatteryState i: Int) {
                      val args: HashMap<String, Any> = HashMap()
                      args["deviceId"] = deviceId
                      args["location"] = i
                      channel.invokeMethod("onBatteryStateUpdateReceived", args)
                    }
                    override fun onStatusUpdateReceived(statusUpdate: StatusUpdate) {
                      val args: HashMap<String, Any> = HashMap()
                      args["deviceId"] = deviceId
                      args["location"] = Gson().toJson(statusUpdate)
                      channel.invokeMethod("onStatusUpdateReceived", args)
                    }
                    override fun onTripUpdateReceived(trip: Trip) {
                      val args: HashMap<String, Any> = HashMap()
                      args["deviceId"] = deviceId
                      args["location"] = Gson().toJson(trip)
                      channel.invokeMethod("onTripUpdateReceived", args)
                    }
                    override fun onError(exception: Exception, deviceId: String) {
                      val args: HashMap<String, Any> = HashMap()
                      args["deviceId"] = deviceId
                      args["location"] = Gson().toJson(exception)
                      channel.invokeMethod("onError", args)
                    }
                    override fun onCompleted(deviceId: String) {
                      val args: HashMap<String, Any> = HashMap()
                      args["deviceId"] = deviceId
                      channel.invokeMethod("onCompleted", args)
                    }
                  }
          )
          result.success(true)
        } else {
          result.error("monke", "Invalid arguments", "deviceId == null")
        }
      }
      "stopAllUpdates" -> mHyperTrackView.stopAllUpdates()
      else -> result.notImplemented()
    }
  }

  private fun checkErrors(call: MethodCall, result: Result): Boolean {
    if (!this::mHyperTrackView.isInitialized) {
      result.error("monke", "SDK not initialized!", "run initialize()")
      return false
    }
    if (call.arguments == null) {
      result.error("squabble", "Invalid arguments", "Expected at least 1 arg")
      return false
    }
    return true
  }
}
