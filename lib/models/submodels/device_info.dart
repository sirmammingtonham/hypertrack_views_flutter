class DeviceInfo {
  /// Version of the hosting app
  String appVersionNumber;

  /// Version of the hosting app
  String appVersionString;

  /// The device brand
  String deviceBrand;

  /// The device model
  String deviceModel;

  /// The name of the device
  String name;

  /// The operating system of the device, can be one of `iOS` or `Android`
  String osName;

  /// The version of the operating system on the device
  String osVersion;

  /// The HyperTrack SDK version on the device.
  String sdkVersion;

  DeviceInfo(
      {this.appVersionNumber,
      this.appVersionString,
      this.deviceBrand,
      this.deviceModel,
      this.name,
      this.osName,
      this.osVersion,
      this.sdkVersion});

  DeviceInfo.fromJson(Map<String, dynamic> json) {
    appVersionNumber = json['app_version_number'];
    appVersionString = json['app_version_string'];
    deviceBrand = json['device_brand'];
    deviceModel = json['device_model'];
    name = json['name'];
    osName = json['os_name'];
    osVersion = json['os_version'];
    sdkVersion = json['sdk_version'];
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
    return data;
  }
}
