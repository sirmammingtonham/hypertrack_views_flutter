enum BatteryState { BATTERY_CHARGING, BATTERY_LOW, BATTERY_NORMAL }
enum DeviceStatus {
  ACTIVITY_PERMISSION_DENIED,
  ACTIVITY_SERVICE_DISABLED,
  ACTIVITY_SERVICE_UNAVAILABLE,
  CYCLE,
  DISCONNECTED,
  DRIVE,
  LOCATION_PERMISSION_DENIED,
  LOCATION_SERVICE_DISABLED,
  MOVING,
  RUN,
  STOP,
  STOPPED_PROGRAMMATICALLY,
  UNKNOWN,
  WALK
}

class Device {
  /// The name of the device
  String name;

  /// The battery state of the device
  int battery;

  /// Version of the hosting app
  String appVersionNumber;

  /// Version of the hosting app
  String appVersionString;

  /// The device brand
  String deviceBrand;

  /// The device model
  String deviceModel;

  /// The operating system of the device, can be one of `iOS` or `Android`
  String osName;

  /// The version of the operating system on the device
  String osVersion;

  /// The HyperTrack SDK version on the device.
  String sdkVersion;

  /// Property provides more extended description of current state,
  /// e.g. whether it it is driving, if active, etc.
  /// See [JavaDoc](https://hypertrack.github.io/sdk-views-android/javadoc/latest/com/hypertrack/sdk/views/dao/DeviceStatus.html#field.summary)
  /// for the list of possible values and their meaning.
  int status;

  /// [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date when the device status was created
  String createdAt;

  Device(
      {this.appVersionNumber,
      this.appVersionString,
      this.deviceBrand,
      this.deviceModel,
      this.name,
      this.osName,
      this.osVersion,
      this.sdkVersion});

  Device.fromJson(Map<dynamic, dynamic> json) {
    name = json['device_info.name'];
    battery = json['device_info.battery'];
    appVersionNumber = json['device_info.app_version_number'];
    appVersionString = json['device_info.app_version_string'];
    deviceBrand = json['device_info.device_brand'];
    deviceModel = json['device_info.device_model'];
    osName = json['device_info.os_name'];
    osVersion = json['device_info.os_version'];
    sdkVersion = json['device_info.sdk_version'];

    createdAt = json['device_status.createdAt'];
    status = int.tryParse(json['device_status.status'].toString()); // works for int and strings
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_version_number'] = this.appVersionNumber;
    data['app_version_string'] = this.appVersionString;
    data['device_brand'] = this.deviceBrand;
    data['device_model'] = this.deviceModel;
    data['name'] = this.name;
    data['os_name'] = this.osName;
    data['os_version'] = this.osVersion;
    data['sdk_version'] = this.sdkVersion;

    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}
