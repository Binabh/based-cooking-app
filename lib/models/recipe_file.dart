class RecipeFile {
  late String path;
  late String mode;
  late String type;
  late String sha;
  late int size;
  late String url;

  RecipeFile({required this.path, required this.mode, required this.type, required this.sha, required this.size, required this.url});

  RecipeFile.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    mode = json['mode'];
    type = json['type'];
    sha = json['sha'];
    size = json['size'] ?? 0;
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    data['mode'] = mode;
    data['type'] = type;
    data['sha'] = sha;
    data['size'] = size;
    data['url'] = url;
    return data;
  }
}
