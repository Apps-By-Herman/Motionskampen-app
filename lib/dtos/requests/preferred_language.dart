class PreferredLanguageRequest {
  String preferredLanguage;

  PreferredLanguageRequest({required this.preferredLanguage});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['preferredLanguage'] = this.preferredLanguage;
    return data;
  }
}
