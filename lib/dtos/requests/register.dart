class RegisterRequest {
  String username;
  String email;
  String password;

  RegisterRequest({required this.username, required this.email,
    required this.password });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}