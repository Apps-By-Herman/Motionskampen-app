class DeviceTokenRequest {
  String deviceToken;

  DeviceTokenRequest({required this.deviceToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceToken'] = this.deviceToken;
    return data;
  }
}
