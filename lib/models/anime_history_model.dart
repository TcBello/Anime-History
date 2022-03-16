class AnimeHistoryModel{
  final int id;
  final String image;
  final String title;

  AnimeHistoryModel({
    this.id = 0,
    this.image = "",
    this.title = ""
  });

  static AnimeHistoryModel fromJSON(Map<String, dynamic> json){
    return AnimeHistoryModel(
      id: json['id'],
      image: json['image'],
      title: json['title']
    );
  }
}