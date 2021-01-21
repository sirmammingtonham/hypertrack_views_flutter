import 'submodels/device_status.dart';
import 'submodels/location.dart';
import 'submodels/trip.dart';
import 'submodels/device_info.dart';

class MovementStatus {
  String deviceId;
  DeviceInfo deviceInfo;
  DeviceStatus deviceStatus;
  Location location;
  List<Trip> trips;

  List<double> get locationCoords => location.geometry.coordinates;

  MovementStatus(
      {this.deviceId,
      this.deviceInfo,
      this.deviceStatus,
      this.location,
      this.trips});

  MovementStatus.fromJson(Map<String, dynamic> json) {
    deviceId = json['device_id'];
    deviceInfo = json['device_info'] != null
        ? new DeviceInfo.fromJson(json['device_info'])
        : null;
    deviceStatus = json['device_status'] != null
        ? new DeviceStatus.fromJson(json['device_status'])
        : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    if (json['trips'] != null) {
      trips = new List<Trip>();
      json['trips'].forEach((v) {
        trips.add(new Trip.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_id'] = this.deviceId;
    if (this.deviceInfo != null) {
      data['device_info'] = this.deviceInfo.toJson();
    }
    if (this.deviceStatus != null) {
      data['device_status'] = this.deviceStatus.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    if (this.trips != null) {
      data['trips'] = this.trips.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
