class AnimeModel{
  final int id;
  final String image;
  final String title;

  AnimeModel({
    this.id = 0,
    this.image = "",
    this.title = ""
  });

  static AnimeModel fromJSON(Map<String, dynamic> json){
    return AnimeModel(
      id: json['mal_id'],
      image: json['images']['jpg']['large_image_url'],
      title: json['title'],
    );
  }
}