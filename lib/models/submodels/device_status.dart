class DeviceStatus {
  // /// [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date when the device status was created
  // final bool isActive;

  // /// Returns `true` if device is active
  // /// (it's current location is known and updated) and `false` otherwise
  // final bool isDisconnected;

  // /// Returns `true` if device is disconnected
  // /// (it's location wasn't updated for a while) and `false` otherwise
  // final bool isInactive;

  /// Returns `true` if tracking data is unavailable because of lack of
  /// permissions or tracking was stopped intentionally and `false` otherwise
  int status;

  /// Property provides more extended description of current state,
  /// e.g. whether it it is driving, if active, etc.
  /// See [JavaDoc](https://hypertrack.github.io/sdk-views-android/javadoc/latest/com/hypertrack/sdk/views/dao/DeviceStatus.html#field.summary)
  /// for the list of possible values and their meaning.
  String createdAt;

  DeviceStatus({this.createdAt, this.status});

  DeviceStatus.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}
