import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'dart:js' as js;

class ImageView extends StatefulWidget {
  final String imgPath;

  ImageView({@required this.imgPath});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgPath,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: kIsWeb
                  ? Image.network(widget.imgPath, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: widget.imgPath,
                      placeholder: (context, url) => Container(
                        color: Color(0xfff5f8fd),
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      if (kIsWeb) {
                        _launchURL(widget.imgPath);
                        //js.context.callMethod('downloadUrl',[widget.imgPath]);
                        //response = await dio.download(widget.imgPath, "./xx.html");
                      } else {
                        _save();
                      }
                      //Navigator.pop(context);
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xff1C1B1B).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white24, width: 1),
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.greenAccent),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Download Wallpaper",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  kIsWeb
                                      ? "Image will open in new tab to download"
                                      : "Image will be saved in gallery",
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.black87),
                                ),
                              ],
                            )),
                      ],
                    )),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async {
    await _askPermission();
    await toast("Downloading...");
    var response = await Dio().get(widget.imgPath,
        options: Options(responseType: ResponseType.bytes));
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    await toast("Wallpaper downloaded successfully");
    Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      await Permission.photos.request();
    } else {
      await Permission.storage.request();
    }
  }

  toast(text) async {
    await Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
