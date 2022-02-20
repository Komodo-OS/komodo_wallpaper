class PhotosModel {
  String creator;
  String name;
  String wallpaper;
  String category;

  PhotosModel({this.creator, this.name, this.wallpaper, this.category});

  factory PhotosModel.fromMap(Map<String, dynamic> parsedJson) {
    return PhotosModel(
        creator: parsedJson["creator"],
        name: parsedJson["name"],
        wallpaper: parsedJson["wallpaper"],
        category: parsedJson["category"]);
  }
}
