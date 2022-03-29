class LoginResponse {
  late String token;
  late int expiry;

  LoginResponse({required this.token, required this.expiry});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiry = json['expiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expiry'] = this.expiry;
    return data;
  }
}

