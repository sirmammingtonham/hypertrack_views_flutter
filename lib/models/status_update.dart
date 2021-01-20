class StatusUpdate {
  /// Health event type, can be one of `DRIVE`, `STOP`, or `WALK`
  final String value;

  /// Health hint. Additional information about the health event
  final String hint;

  /// [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date when the device status was recorded
  final String recordedAt;

  StatusUpdate(this.value, this.hint, this.recordedAt);
}
