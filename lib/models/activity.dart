class Activity {
  late int id;
  late String name;
  late int activeMinutes;
  late DateTime created;
  late String username;

  Activity({
    required this.id,
    required this.name,
    required this.activeMinutes,
    required this.created,
    required this.username,
  });

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    activeMinutes = json['activeMinutes'];
    created = DateTime.parse(json['created']+"Z");
    username = json['username'];
  }
}
