import 'geometry.dart';
import 'device_view_urls.dart';

class Trip {
  /// Unique identifier of the newly created trip, case sensitive
  String tripId;

  /// Trip status, can be either `active` or `completed`
  String status;

  /// Timestamp for trip starting time
  String startedAt;

  /// Metadata provided at trip start
  String metadata;

  /// Trip summary, only provided upon completion of a trip
  String summary;

  /// Destination of the trip, or `null` if trip has no destination
  TripDestination destination;

  // /// Trip summary, only provided for trips with status `active`
  // TripEstimate estimate;

  /// [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date when the trips was completed or null if it haven't been completed
  String completedAt;

  List<Null> geofences;
  DeviceViewUrls views;

  Trip(
      {this.destination,
      this.geofences,
      this.metadata,
      this.startedAt,
      this.status,
      this.tripId,
      this.views});

  Trip.fromJson(Map<String, dynamic> json) {
    destination = json['destination'] != null
        ? new TripDestination.fromJson(json['destination'])
        : null;
    if (json['geofences'] != null) {
      geofences = new List<Null>();
      json['geofences'].forEach((v) {
        geofences.add(null);
      });
    }
    metadata = json['metadata'];
    startedAt = json['started_at'];
    status = json['status'];
    tripId = json['trip_id'];
    views = json['views'] != null
        ? new DeviceViewUrls.fromJson(json['views'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.destination != null) {
      data['destination'] = this.destination.toJson();
    }
    if (this.geofences != null) {
      data['geofences'] = this.geofences.map((v) => null).toList();
    }
    data['metadata'] = this.metadata;
    data['started_at'] = this.startedAt;
    data['status'] = this.status;
    data['trip_id'] = this.tripId;
    if (this.views != null) {
      data['views'] = this.views.toJson();
    }
    return data;
  }
}

class TripDestination {
  // /// Latitude coordinate of destination center point in degrees. Negatives are for southern hemisphere
  // double latitude;
  // /// Longitude coordinate of destination center point in degrees. Negatives are for western hemisphere
  // double longitude;
  // /// Timestamp for scheduled arrival ??
  // String scheduledAt;

  /// Radius (in meters) of a circular trip destination
  int radius;
  String address;
  Geometry geometry;

  TripDestination({this.address, this.geometry, this.radius});

  TripDestination.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    radius = json['radius'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['radius'] = this.radius;
    return data;
  }
}

// class TripEstimate {
//   /// Timestamp for estimated arrival
//   final String arriveAt;
//   /// Planned route segments to destination
//   final TripRoute route;

//   TripEstimate(this.arriveAt, this.route);
// }

// class TripRoute {
//   /// Length of route ??
//   final int distance;
//   /// Duration in seconds
//   final int duration;
//   /// Street address lookup for segment start
//   final String startAddress;
//   /// Street address lookup for segment end
//   final String endAddress;
//   /// Planned route segments to destination, as array of longitude, latitude and altitude (optional) tuples
//   final List<List<double>> points;

//   TripRoute(this.distance, this.duration, this.startAddress, this.endAddress,
//       this.points);
// }
