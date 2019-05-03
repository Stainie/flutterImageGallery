import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'dart:async';
import 'dart:math';

import 'gallery.dart';
import 'login.dart';

import '../cache/domain_cache.dart';

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
    DomainCache.galleryImages = new List<File>();

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
    const jsonCodec = const JsonCodec();
    bool logged = false;

    if (prefs.getBool("logged") != null) {
      logged = prefs.getBool("logged");
    }

    if (logged) {
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
