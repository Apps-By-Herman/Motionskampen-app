class CreateActivityRequest {
  int activeMinutes;
  String? name;

  CreateActivityRequest({required this.activeMinutes, this.name});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activeMinutes'] = this.activeMinutes;
    data['name'] = this.name;
    return data;
  }
}