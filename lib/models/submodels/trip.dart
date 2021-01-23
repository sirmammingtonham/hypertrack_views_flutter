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

  /// Embeddable view URL
  String embedURL;

  /// Sharable view URL
  String shareURL;

  /// Destination of the trip, or `null` if trip has no destination
  TripDestination destination;

  /// Estimated arrival time
  String arriveAt;

  /// Polyline route, only provided for trips with status `active`
  List<List<double>> route;

  Trip(
      {this.tripId,
      this.status,
      this.startedAt,
      this.metadata,
      this.summary,
      this.embedURL,
      this.shareURL,
      this.destination,
      this.arriveAt,
      this.route});

  Trip.fromJson(Map<dynamic, dynamic> json) {
    tripId = json["trip_id"];
    status = json["status"];
    startedAt = json["startedAt"];
    metadata = json["metadata"];
    summary = json["summary"];
    embedURL = json["embedURL"];
    shareURL = json["shareURL"];
    metadata = json['metadata'];
    startedAt = json['started_at'];
    status = json['status'];
    tripId = json['trip_id'];

    destination = TripDestination.fromJson(json);

    arriveAt = json['estimate.arriveAt'];
    route = json['estimate.route'] as List<List<double>>;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["trip_id"] = tripId;
    data["status"] = status;
    data["startedAt"] = startedAt;
    data["metadata"] = metadata;
    data["summary"] = summary;
    data["embedURL"] = embedURL;
    data["shareURL"] = shareURL;
    data['metadata'] = metadata;
    data['started_at'] = startedAt;
    data['status'] = status;
    data['trip_id'] = tripId;
    data['destination'] = destination.toJson();
    data['estimate.arriveAt'] = arriveAt;
    data['estimate.route'] = route;
    return data;
  }
}

class TripDestination {
  /// Radius (in meters) of a circular trip destination
  int radius;

  /// Address of destination
  String address;

  /// Latitude coordinate of destination center point in degrees. Negatives are for southern hemisphere
  double latitude;

  /// Longitude coordinate of destination center point in degrees. Negatives are for western hemisphere
  double longitude;

  /// time of arrival for completed trips?
  String arrivedAt;

  /// time trip was exited?
  String exitedAt;

  /// Timestamp trip was scheduled at
  String scheduledAt;

  TripDestination(
      {this.radius,
      this.address,
      this.latitude,
      this.longitude,
      this.arrivedAt,
      this.exitedAt,
      this.scheduledAt});

  List<double> get locationCoords => [latitude, longitude];

  TripDestination.fromJson(Map<dynamic, dynamic> json) {
    address = json["destination.address"];
    radius = json["destination.radius"];
    latitude = json["destination.latitude"];
    longitude = json["destination.longitude"];
    arrivedAt = json["destination.arrivedAt"];
    exitedAt = json["destination.exitedAt"];
    scheduledAt = json["destination.scheduledAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["address"] = address;
    data["radius"] = radius;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["arrivedAt"] = arrivedAt;
    data["exitedAt"] = exitedAt;
    data["scheduledAt"] = scheduledAt;
    return data;
  }
}
