import 'dart:convert';
import 'submodels/location.dart';
import 'submodels/trip.dart';
import 'submodels/device.dart';

class MovementStatus {
  /// the device id corresponding to the movement status
  String deviceId;

  /// a [Device] object containing info about the device the status came from
  Device deviceInfo;

  /// a [Location] object containing info about the device's current location
  Location location;

  /// a [List] of [Trip] objects containing information about each trip the device
  /// is on
  List<Trip> trips;

  /// getter for location coordinates (lat,lng)
  List<double> get locationCoords => location.locationCoords;

  MovementStatus({this.deviceId, this.deviceInfo, this.location, this.trips});

  MovementStatus.fromJson(Map<dynamic, dynamic> json) {
    deviceId = json['device_id'];
    deviceInfo = Device.fromJson(json);
    location = Location.fromJson(json);
    trips = List<Trip>();
    json['trips']?.forEach((v) {
      trips.add(new Trip.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_id'] = this.deviceId;
    data['device_info'] = this.deviceInfo.toJson();
    data['location'] = this.location.toJson();
    data['trips'] = this.trips.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
