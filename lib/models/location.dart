import 'geometry.dart';

class Location {
  // /// Latitude in degrees. Negatives are for southern hemisphere.
  // double latitude;
  // /// Longitude in degrees. Negatives are for western hemisphere.
  // double longitude;
  Geometry geometry;

  /// Altitude in m. Could be `null`, if value is not available.
  double altitude;

  /// Speed in m/s. Could be `null`, if device is stationary
  double speed;

  /// Bearing in degrees starting at due north and continuing clockwise around the compass
  double bearing;

  /// Horizontal accuracy in m
  double accuracy;

  /// [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date when the location was recorded
  String recordedAt;

  Location(
      {this.accuracy,
      this.bearing,
      this.geometry,
      this.recordedAt,
      this.speed});

  Location.fromJson(Map<String, dynamic> json) {
    accuracy = json['accuracy'];
    bearing = json['bearing'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    recordedAt = json['recorded_at'];
    speed = json['speed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accuracy'] = this.accuracy;
    data['bearing'] = this.bearing;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['recorded_at'] = this.recordedAt;
    data['speed'] = this.speed;
    return data;
  }
}
