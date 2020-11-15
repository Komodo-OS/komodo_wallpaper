class PhotosModel {
  String creator;
  String name;
  String wallpaper;

  PhotosModel(
      {this.creator,
      this.name,
      this.wallpaper});

  factory PhotosModel.fromMap(Map<String, dynamic> parsedJson) {
    return PhotosModel(
        creator: parsedJson["creator"],
        name: parsedJson["name"],
        wallpaper: parsedJson["wallpaper"]);
  }
}
