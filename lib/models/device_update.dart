import 'submodels/trip.dart';
import 'submodels/status_update.dart';
import 'submodels/location.dart';

class DeviceUpdate {
  Trip trip;
  StatusUpdate statusUpdate;
  Location location;
  String deviceId;

  List<double> get locationCoords => location.geometry.coordinates.sublist(0,2);

  DeviceUpdate({this.trip, this.statusUpdate, this.location, this.deviceId});

  DeviceUpdate.fromJson(Map<String, dynamic> json) {
    trip = json['trip'] != null ? new Trip.fromJson(json['trip']) : null;
    statusUpdate = json['statusUpdate'] != null
        ? new StatusUpdate.fromJson(json['statusUpdate'])
        : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trip != null) {
      data['trip'] = this.trip.toJson();
    }
    if (this.statusUpdate != null) {
      data['statusUpdate'] = this.statusUpdate.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['deviceId'] = this.deviceId;
    return data;
  }
}
