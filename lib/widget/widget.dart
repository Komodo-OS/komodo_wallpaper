import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:komodowalls/models/photos_model.dart';
import 'package:komodowalls/view/image_view.dart';

Widget wallPaper(List<PhotosModel> listPhotos, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 6.0,
        children: listPhotos.map((PhotosModel photoModel) {
          return GridTile(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageView(
                                imgPath: photoModel.wallpaper,
                              )));
                },
                child: Hero(
                  tag: photoModel.wallpaper,
                  child: Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: kIsWeb
                            ? Image.network(
                                photoModel.wallpaper,
                                height: 50,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: photoModel.wallpaper,
                                placeholder: (context, url) => Container(
                                  color: Color(0xfff5f8fd),
                                ),
                                fit: BoxFit.cover,
                              )),
                  ),
                ),
              ),
              footer: Text(
                photoModel.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    backgroundColor: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.greenAccent,
                    fontFamily: 'Overpass'),
              ));
        }).toList()),
  );
}

Widget brandName() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Komodo",
        style: TextStyle(color: Colors.black, fontFamily: 'Overpass'),
      ),
      Text(
        "Walls",
        style: TextStyle(color: Colors.greenAccent, fontFamily: 'Overpass'),
      )
    ],
  );
}
