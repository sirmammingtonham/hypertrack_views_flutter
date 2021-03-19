library hypertrack_views_flutter;

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:streams_channel/streams_channel.dart';

// model imports
import 'package:hypertrack_views_flutter/models/movement_status.dart';

// exports
export 'package:hypertrack_views_flutter/models/movement_status.dart';

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
  bool initialized;

  HypertrackViewsFlutter(this._publishableKey) {
    _channel.invokeMethod('initialize', _publishableKey).then((_) {
      initialized = true;
      print('hypertrack_views_flutter initialized successfully');
    }).catchError((_) {
      initialized = false;
      print('ERROR! hypertrack_views_flutter failed to initialize');
    });
  }

  Future<MovementStatus> getDeviceUpdate(String deviceId) async {
    assert(initialized);
    var data = await _channel.invokeMethod('getDeviceMovementStatus', deviceId);
    return MovementStatus.fromJson(data);
  }

  Stream<MovementStatus> subscribeToDeviceUpdates(String deviceId) {
    assert(initialized);
    return _stream
        .receiveBroadcastStream(deviceId)
        .map<MovementStatus>((eventData) {
      return MovementStatus.fromJson(eventData);
    });
  }
}
