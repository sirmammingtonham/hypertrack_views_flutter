class StatusUpdate {
  /// Health event type, can be one of `DRIVE`, `STOP`, or `WALK`
  String value;

  /// Health hint. Additional information about the health event
  String hint;

  /// [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date when the device status was recorded
  String recordedAt;

  StatusUpdate({this.value, this.hint, this.recordedAt});

  StatusUpdate.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    recordedAt = json['recordedAt'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hint'] = this.hint;
    data['recordedAt'] = this.recordedAt;
    data['value'] = this.value;
    return data;
  }
}
