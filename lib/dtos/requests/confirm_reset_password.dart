class ConfirmResetPasswordRequest {
  String email;
  String token;
  String password;

  ConfirmResetPasswordRequest({
    required this.email,
    required this.token,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['token'] = this.token;
    data['password'] = this.password;
    return data;
  }
}
