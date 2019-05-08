import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../helping_scripts/handlers/request_handler.dart';
import '../CONSTANTS/constant_routes.dart';

import 'gallery.dart';
import 'login.dart';

import '../model/user.dart';
import '../model/gallery_image.dart';

import '../cache/domain_cache.dart';
import '../model/gallery_image_server.dart';
import '../model/comment.dart';

class LandingPage extends StatefulWidget {
  @override
  LandingPageState createState() => new LandingPageState();
}

class LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  double _progressValue = 0.0;
  String _progressText = "Fetching Photos";

  AnimationController _controller;
  Animation<double> animation;
  final _jsonCodec = const JsonCodec();

  final title = Center(
    child: Text("HolyGallery",
        style: const TextStyle(
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w700,
            fontFamily: "Poppins",
            fontStyle: FontStyle.normal,
            fontSize: 38.0)),
  );

  void _increaseAmount() {
    for (var i = 0; i < 20; i++) {
      Future.delayed(Duration(milliseconds: 200), _fillBar);
    }
  }

  Future<bool> _fillBar() async {
    setState(() {
      _progressValue += 0.02;
    });

    return true;
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() => setState(() {}));

    animation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(_controller);

    _controller.forward();

    _initAll();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<bool> _initAll() async {
    _increaseAmount();

    await Future.delayed(Duration(seconds: 1));

    _increaseAmount();
    setState(() {
      _progressText = "Reading Comments";
    });

    await Future.delayed(Duration(seconds: 1));

    _increaseAmount();
    setState(() {
      _progressText = "Loading Camera";
    });

    await Future.delayed(Duration(seconds: 1));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool logged = false;

    if (prefs.getBool("logged") != null) {
      logged = prefs.getBool("logged");
    }

    if (logged) {
      if (prefs.getString("email") == null) {
        prefs.setBool("logged", false);
        _initAll();
        return true;
      }

      /* --- USED FOR SERVER VERSION ---*/

      /* http.Response responseImages = await RequestHandler.executeGetRequest(ConstantRoutes.getImages + prefs.getString("uuid"));

      var responseData = _jsonCodec.decode(responseImages.body);

      List<GalleryImageServer> images = new List<GalleryImageServer>();

      List imagesBody = responseData["info"];

      for (var i = 0; i < imagesBody.length; i++) {
        GalleryImageServer img = new GalleryImageServer(imagesBody[i]["title"], imagesBody[i]["imageUrl"]);
        img.setUuid(imagesBody[i]["uuid"]);

        http.Response responseComments = await RequestHandler.executeGetRequest(ConstantRoutes.getComments + img.uuid);
        var responseDataComments = _jsonCodec.decode(responseComments.body);
        List commentsBody = responseDataComments["info"];

        for (var j = 0; j < commentsBody.length; j++) {
          img.comments.add(new Comment(commentsBody[j]["text"], commentsBody[j]["timeWritten"], commentsBody[j]["writter"]));
        }

        images.add(img);
      }

      DomainCache.galleryImagesServer = images; */

      http.Response responseUser = await RequestHandler.executeGetRequest(
          ConstantRoutes.getUser + prefs.getString("email"));

      var responseUserData = _jsonCodec.decode(responseUser.body);

      User user = new User(responseUserData["user"]["email"],
          responseUserData["user"]["password"]);

      DomainCache.user = user;

      List<GalleryImage> images = new List<GalleryImage>();
      List decodedImages = prefs.getString("images") != null
          ? _jsonCodec.decode(prefs.getString("images"))
          : null;

      if (decodedImages != null) {
        for (var i = 0; i < decodedImages.length; i++) {
          List<Comment> comments = new List<Comment>();
          List decodedCommens = decodedImages[i]["comments"];

          for (var j = 0; j < decodedCommens.length; j++) {
            print("Entered comments");
            Comment com = new Comment(
                decodedCommens[j]["text"],
                DateTime.parse(decodedCommens[j]["timeWritten"]),
                decodedCommens[j]["writter"]);
            comments.add(com);
          }

          GalleryImage img = new GalleryImage(decodedImages[i]["file"],
              DateTime.parse(decodedImages[i]["timeTaken"]), comments);
          images.add(img);
        }
      }

      DomainCache.galleryImages = images;

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GalleryPage()));
      return true;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

    return true;
  }

  math.Vector3 _getTranslation() {
    double progress = _controller.value;
    double offset = sin(progress * pi * 10.0);
    return math.Vector3(offset * 4, 0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    Widget _wDesc = Center(
      child: Text(_progressText,
          style: const TextStyle(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w400,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
              fontSize: 14.0)),
    );

    Widget _wLoader = LinearProgressIndicator(
      value: _progressValue,
      valueColor: new AlwaysStoppedAnimation(Colors.white),
      backgroundColor: const Color(0xff2b3034).withOpacity(0.4),
    );

    Widget _wLogo = Transform(
        transform: Matrix4.translation(_getTranslation()),
        child: Hero(
          tag: 'logo',
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 70.0 * (MediaQuery.of(context).size.width / 375.0),
            child: Image.asset('assets/logo.png'),
          ),
        ));

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  const Color(0xff17ead9),
                  const Color(0xff6078ea)
                ])),
            child: Center(
                child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        left: 70 * (MediaQuery.of(context).size.width / 375.0),
                        right:
                            70 * (MediaQuery.of(context).size.width / 375.0)),
                    children: <Widget>[
                  SizedBox(
                    height: 20.0 * (MediaQuery.of(context).size.height / 667.0),
                  ),
                  _wLogo,
                  SizedBox(
                    height: 5.0 * (MediaQuery.of(context).size.height / 667.0),
                  ),
                  title,
                  SizedBox(height: MediaQuery.of(context).size.height * 0.5),
                  _wLoader,
                  SizedBox(
                    height: 5.0 * (MediaQuery.of(context).size.height / 667.0),
                  ),
                  _wDesc
                ]))));
  }
}
