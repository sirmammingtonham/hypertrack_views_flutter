class Location {
  /// Latitude in degrees. Negatives are for southern hemisphere.
  double latitude;

  /// Longitude in degrees. Negatives are for western hemisphere.
  double longitude;

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
      {this.latitude,
      this.longitude,
      this.accuracy,
      this.bearing,
      this.recordedAt,
      this.speed});

  List<double> get locationCoords => [latitude, longitude];

  Location.fromJson(Map<dynamic, dynamic> json) {
    latitude = json['location.latitude'];
    longitude = json['location.longitude'];
    altitude = json['location.altitude'];
    speed = json['location.speed'];
    bearing = json['location.bearing'];
    accuracy = json['location.accuracy'];
    recordedAt = json['location.recordedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['altitude'] = this.altitude;
    data['speed'] = this.speed;
    data['bearing'] = this.bearing;
    data['accuracy'] = this.accuracy;
    data['recordedAt'] = this.recordedAt;
    return data;
  }
}
