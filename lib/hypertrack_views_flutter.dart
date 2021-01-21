import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:streams_channel/streams_channel.dart';

// model imports
import 'package:hypertrack_views_flutter/models/movement_status.dart';
import 'package:hypertrack_views_flutter/models/device_update.dart';

class HypertrackViewsFlutter {
  static const MethodChannel _channel =
      const MethodChannel('hypertrack_views_flutter/methods');

  final StreamsChannel _stream =
      StreamsChannel('hypertrack_views_flutter/events');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  final String _publishableKey;

  HypertrackViewsFlutter(this._publishableKey) {
    _channel.invokeMethod('initialize', _publishableKey).then((_) {
      print('hypertrack_views_flutter initialized successfully');
    });
  }

  Future<MovementStatus> getDeviceMovementStatus(String deviceId) async {
    String serialized =
        await _channel.invokeMethod('getDeviceMovementStatus', deviceId);
    log(serialized);
    return MovementStatus.fromJson(json.decode(serialized));
  }

  Stream<DeviceUpdate> subscribeToDeviceUpdates(String deviceId) {
    return _stream
        .receiveBroadcastStream(deviceId)
        .map<DeviceUpdate>((eventData) {
      return DeviceUpdate.fromJson(eventData);
    });
  }
}
