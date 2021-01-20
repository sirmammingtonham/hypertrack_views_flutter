import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

// model imports
import 'package:hypertrack_views_flutter/models/battery_state.dart';
import 'package:hypertrack_views_flutter/models/location.dart';
import 'package:hypertrack_views_flutter/models/status_update.dart';
import 'package:hypertrack_views_flutter/models/movement_status.dart';
import 'package:hypertrack_views_flutter/models/trip.dart';

typedef Future<void> CancelSubscription();
typedef void UpdateCallback<T>(String deviceId, T args);

class HypertrackViewsFlutter {
  static const MethodChannel _channel =
      const MethodChannel('hypertrack_views_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  final String _publishableKey;
  final UpdateCallback movementStatusCallback;
  final UpdateCallback<Location> onLocationUpdateRecieved;
  final UpdateCallback<BatteryState> onBatteryStateUpdateRecieved;
  final UpdateCallback<StatusUpdate> onStatusUpdateReceived;
  final UpdateCallback<Trip> onTripUpdateReceived;
  final UpdateCallback<String> onError;
  final UpdateCallback<String> onCompleted;

  HypertrackViewsFlutter(this._publishableKey,
      {this.movementStatusCallback,
      this.onLocationUpdateRecieved,
      this.onBatteryStateUpdateRecieved,
      this.onStatusUpdateReceived,
      this.onTripUpdateReceived,
      this.onError,
      this.onCompleted}) {
    _channel.setMethodCallHandler(_methodCallHandler);
    _channel.invokeMethod('initialize', _publishableKey).then((_) {
      print('hypertrack_views_flutter initialized successfully');
    //   // _channel.setMethodCallHandler(_methodCallHandler);
    });
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    String deviceId = call.arguments["deviceId"];
    switch (call.method) {
      case 'onLocationUpdateRecieved':
        onLocationUpdateRecieved(deviceId, call.arguments);
        break;
      case 'onBatteryStateUpdateRecieved':
        onBatteryStateUpdateRecieved(deviceId, call.arguments);
        break;
      case 'onStatusUpdateReceived':
        onStatusUpdateReceived(deviceId, call.arguments);
        break;
      case 'onTripUpdateReceived':
        onTripUpdateReceived(deviceId, call.arguments);
        break;
      case 'onError':
        onError(deviceId, call.arguments);
        break;
      case 'onCompleted':
        onCompleted(deviceId, call.arguments);
        break;
      default:
        print(
            'Hypertrack: Ignoring invoke from native. This normally shouldn\'t happen; tf you do?');
    }
  }

  Future<MovementStatus> getDeviceMovementStatus(String deviceId) async {
    String serialized =
        await _channel.invokeMethod('getDeviceMovementStatus', deviceId);
    log(serialized);
    return MovementStatus.fromJson(json.decode(serialized));
  }

  Future<CancelSubscription> subscribeToDeviceUpdates(String deviceId) async {
    await _channel.invokeMethod('subscribeToDeviceUpdates', deviceId);
    return () {
      _channel.invokeMethod('stopAllUpdates');
    };
  }
}
