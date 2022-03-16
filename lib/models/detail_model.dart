class DetailModel{
  final int id;
  final String type;
  final String name;
  final String url;

  DetailModel({
    this.id = 0,
    this.type = "",
    this.name = "",
    this.url = ""
  });

  static DetailModel fromJSON(Map<String, dynamic> json){
    return DetailModel(
      id: json['mal_id'],
      type: json['type'],
      name: json['name'],
      url: json['url'],
    );
  }
}