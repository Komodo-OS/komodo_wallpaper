import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:wallpaper/models/photos_model.dart';
import 'package:wallpaper/widget/widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<PhotosModel> photos = new List();

  getListWallpaper() async {
    await http.get(
        "https://device.komodo-os.my.id/wallpaper/api/data.json").then((value) {
      //print(value.body);

      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["result"].forEach((element) {
        //print(element);
        PhotosModel photosModel = new PhotosModel();
        photosModel = PhotosModel.fromMap(element);
        photos.add(photosModel);
        //print(photosModel.toString()+ "  "+ photosModel.src.portrait);
      });

      setState(() {});
    });
  }

  TextEditingController searchController = new TextEditingController();

  ScrollController _scrollController = new ScrollController();

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  @override
  void initState() {
    //getWallpaper();
    getListWallpaper();
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getListWallpaper();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 16,
              ),
              wallPaper(photos, context),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Text(
                    "Wallpaper by ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontFamily: 'Overpass'),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL("https://github.com/Komodo-OS-Devices/komodo-os-devices.github.io/tree/master/wallpaper/api/");
                    },
                    child: Container(
                      child: Text(
                        "community",
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                          fontFamily: 'Overpass'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
