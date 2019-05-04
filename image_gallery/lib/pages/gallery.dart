import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_amazon_s3/flutter_amazon_s3.dart';

import 'single_image.dart';
import 'login.dart';

import '../helping_scripts/handlers/prefs_handler.dart';
import '../helping_scripts/handlers/click_handler.dart';
import '../helping_scripts/view_generators/card_generator.dart';
import '../cache/domain_cache.dart';

import '../model/comment.dart';
import '../model/gallery_image.dart';

class GalleryPage extends StatefulWidget {
  @override
  GalleryPageState createState() => new GalleryPageState();
}

class GalleryPageState extends State<GalleryPage> {
  List<GalleryImage> _galleryImages = new List<GalleryImage>();
  PrefsHandler _prefs;
  ClickHandler _click;
  
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();

  GalleryPageState() {
    _prefs = new PrefsHandler();
    _click = new ClickHandler();
  }

  List<CardItem> _buildList(List<GalleryImage> galleryImages) {
    return galleryImages
        .map((galleryImg) => new CardItem(
            galleryImg, galleryImages.indexOf(galleryImg), routeToImage))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   _galleryImages = DomainCache.galleryImages;
    // });
  }

  void routeToImage(GalleryImage image) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SingleImage(image)));
  }

  Future<bool> closeApp() async {
    exit(0);

    return true;
  }

  Future<bool> pickImageCamera() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);

    // DomainCache.galleryImages.add(img);

    String uploadedImageUrl = await FlutterAmazonS3.uploadImage(
          img.path, "BUCKET_NAME", "IDENTITY_POOL_ID");

    setState(() {
      _galleryImages
          .add(new GalleryImage(img, DateTime.now(), new List<Comment>()));
    });

    return true;
  }

  Future<bool> pickImageGallery() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);

    // DomainCache.galleryImages.add(img);

    String uploadedImageUrl = await FlutterAmazonS3.uploadImage(
          img.path, "BUCKET_NAME", "IDENTITY_POOL_ID");

    setState(() {
      _galleryImages
          .add(new GalleryImage(img, DateTime.now(), new List<Comment>()));
    });

    return true;
  }

  Future<bool> saveUnlogged() async {
    _prefs.setBool("logged", false);
    _prefs.setString("uuid", "");
    _prefs.setString("token", "");

    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget _wDrawer = Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Test User",
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                    color: const Color(0xff9b9b9b),
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.8,
                    fontSize: 16.0)),
            accountEmail: Text(_prefs.getString("email"),
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                    color: const Color(0xff9b9b9b),
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.8,
                    fontSize: 16.0)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://cdn1.iconfinder.com/data/icons/ninja-things-1/1772/ninja-simple-512.png"),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        "https://img3.stockfresh.com/files/v/victoria_andreas/m/95/1856355_stock-photo-gallery-interior-with-empty-frames-on-blue-wall.jpg"))),
          ),
          ListTile(
            dense: true,
            leading: GestureDetector(
              onTap: () => _click.clickActionOnce(saveUnlogged),
              child: Icon(
                Icons.arrow_back_ios,
                color: const Color(0xffc8c6c9),
                size: 18.0,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text("Log out",
                  style: const TextStyle(
                      letterSpacing: 0.89,
                      color: const Color(0xff9b9b9b),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0)),
            ),
          ),
          ListTile(
            dense: true,
            title: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text("Close",
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      color: const Color(0xff9b9b9b),
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.8,
                      fontSize: 16.0)),
            ),
            trailing: Icon(Icons.close),
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );

    Widget _wGalleryAppBar = AppBar(
      leading: IconButton(
          icon: new Image.asset(
            "assets/burger.png",
            width: 18.0,
            height: 19.0,
          ),
          onPressed: () => _drawerKey.currentState.openDrawer()),
      elevation: 0.6,
      centerTitle: true,
      iconTheme: new IconThemeData(color: Colors.grey),
      title: Text("Gallery",
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
              color: const Color(0xff9b9b9b),
              fontStyle: FontStyle.normal,
              letterSpacing: 0.8,
              fontSize: 16.0)),
      backgroundColor: const Color(0xfffafcff),
      actions: <Widget>[
        IconButton(
            icon: new Image.asset(
              "assets/gallery.png",
              width: 20.0,
              height: 18.0,
            ),
            onPressed: pickImageGallery),
        IconButton(
            icon: new Image.asset(
              "assets/camera.png",
              width: 20.0,
              height: 18.0,
            ),
            onPressed: pickImageCamera)
      ],
    );

    Widget _wGalleryScroll = new Expanded(
        child: _galleryImages == null || _galleryImages.length == 0
            ? new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Icon(Icons.camera_alt,
                        color: const Color(0xff9b9b9b), size: 60.0),
                    new Text("No images available",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: const Color(0xff4a4a4a),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0))
                  ],
                ),
              )
            : new ListView(
                padding:
                    new EdgeInsets.symmetric(vertical: 8.0, horizontal: 17.0),
                children: _buildList(_galleryImages),
              ));

    return WillPopScope(
      onWillPop: () async => closeApp(),
      child: Scaffold(
        backgroundColor: const Color(0xfffafcff),
        key: _drawerKey,
        appBar: _wGalleryAppBar,
        drawer: _wDrawer,
        body: Container(
          child: Column(
            children: <Widget>[
              _wGalleryScroll,
            ],
          ),
        ),
      ),
    );
  }
}
