class CreateTeamRequest {
  String name;
  String description;
  String? imageURL;
  List<String> userIds;

  CreateTeamRequest({
    required this.name,
    required this.description,
    this.imageURL,
    required this.userIds,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['imageURL'] = this.imageURL;
    data['userIds'] = this.userIds;
    return data;
  }
}
