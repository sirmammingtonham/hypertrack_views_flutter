class DeviceViewUrls {
  /// Embeddable view URL
  String embedUrl;

  /// Sharable view URL
  String shareUrl;

  DeviceViewUrls({this.embedUrl, this.shareUrl});

  DeviceViewUrls.fromJson(Map<String, dynamic> json) {
    embedUrl = json['embed_url'];
    shareUrl = json['share_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['embed_url'] = this.embedUrl;
    data['share_url'] = this.shareUrl;
    return data;
  }
}
