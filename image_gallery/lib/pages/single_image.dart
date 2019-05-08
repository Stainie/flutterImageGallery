import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../helping_scripts/handlers/prefs_handler.dart';
import '../helping_scripts/handlers/request_handler.dart';

import '../CONSTANTS/constant_routes.dart';
import '../cache/domain_cache.dart';

import 'login.dart';

import '../model/gallery_image.dart';
import '../model/gallery_image_server.dart';
import '../model/comment.dart';

class SingleImage extends StatefulWidget {
  final GalleryImage _image;
  final int _index;
  SingleImage(this._image, this._index);

  @override
  SingleImageState createState() => new SingleImageState(_image, _index);

  /* --- USED FOR SERVER VERSION --- */

  /* final GalleryImageServer _imageServer;
  SingleImage(this._image, this._imageServer); 

  @override
  SingleImageState createState() => new SingleImageState(_image, _imageServer); */
}

class SingleImageState extends State<SingleImage> {
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  final GalleryImage _image;
  final int _index;

  final _commentController = TextEditingController();
  PrefsHandler _prefs;
  final _jsonCodec = const JsonCodec();

  SingleImageState(this._image, this._index) {
    _prefs = new PrefsHandler();
  }

  /* --- USED FOR SERVER VERSION ---*/

  /*final GalleryImageServer _imageServer;
  SingleImageState(this._image, this._imageServer) {
    _prefs = new PrefsHandler();
  } */

  Future<bool> _addComment(String text) async {
    Comment comment =
        new Comment(text, DateTime.now(), _prefs.getString("email"));

    setState(() {
      _image.comments.add(comment);
    });

    DomainCache.galleryImages[_index] = _image;

    var json = _jsonCodec.encode(DomainCache.galleryImages);

    _prefs.setString("images", json);
    _commentController.text = "";

    /* --- USED FOR SERVER VERSION ---*/

    /* setState(() {
      _imageServer.comments.add(comment);
    });

    var json = _jsonCodec.encode(comment);
    http.Response responseAddComment = await RequestHandler.executePostRequest(
        ConstantRoutes.getComments + _imageServer.uuid, json); */

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
            accountEmail: Text(DomainCache.user.email,
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
              onTap: () => saveUnlogged(),
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
            onTap: () => Navigator.of(context).pop(),
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
          )
        ],
      ),
    );

    Widget _wImageAppBar = AppBar(
      leading: IconButton(
          icon: new Image.asset(
            "assets/burger.png",
            width: 18.0,
            height: 19.0,
          ),
          onPressed: () => _drawerKey.currentState.openDrawer()),
      elevation: 0.0,
      centerTitle: true,
      iconTheme: new IconThemeData(color: Colors.grey),
      title: Text("Single Image",
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
              color: const Color(0xff9b9b9b),
              fontStyle: FontStyle.normal,
              letterSpacing: 0.8,
              fontSize: 16.0)),
      backgroundColor: const Color(0xfffafcff),
    );

    Widget _wCommentTextInput = Theme(
        data: ThemeData(
            cursorColor: const Color(0xff4a4a4a),
            primaryColor: const Color(0xff4a4a4a),
            accentColor: const Color(0xff4a4a4a),
            canvasColor: const Color(0xff4a4a4a),
            highlightColor: const Color(0xff4a4a4a),
            hintColor: const Color(0xff4a4a4a)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
          child: TextField(
              controller: _commentController,
              onSubmitted: (text) => _addComment(text),
              autofocus: false,
              style: TextStyle(
                  letterSpacing:
                      1.0 * (MediaQuery.of(context).size.width / 375.0),
                  color: const Color(0xff4a4a4a),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0 * (MediaQuery.of(context).size.width / 375.0)),
              decoration: InputDecoration(
                helperStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(
                    color: const Color(0xff4a4a4a),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                    fontStyle: FontStyle.normal,
                    fontSize:
                        14.0 * (MediaQuery.of(context).size.width / 375.0)),
                hintText: "Add a comment ...",
                hintStyle: TextStyle(
                    color: const Color(0xff4a4a4a),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                    fontStyle: FontStyle.normal,
                    fontSize:
                        14.0 * (MediaQuery.of(context).size.width / 375.0)),
                contentPadding: EdgeInsets.only(
                    top: 15.0 * (MediaQuery.of(context).size.width / 375.0)),
              )),
        ));

    Widget _wPerksExpand = Container(
      width: MediaQuery.of(context).size.width - 26.0,
      height: _image.comments.length *
          43.0 *
          (MediaQuery.of(context).size.width / 375.0),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _image.comments.length,
              itemBuilder: (BuildContext context, int index) {
                return new Opacity(
                  opacity: 0.8,
                  child: Card(
                    margin: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
                    elevation: 1.0,
                    child: Container(
                      height:
                          43.0 * (MediaQuery.of(context).size.width / 375.0),
                      width: MediaQuery.of(context).size.width - 32.0,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20.0 *
                                (MediaQuery.of(context).size.width / 375.0),
                            right: 20.0 *
                                (MediaQuery.of(context).size.width / 375.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _image.comments[index].text,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  color: const Color(0xff4a4a4a),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                    _image.comments[index].timeWritten.day
                                            .toString() +
                                        "." +
                                        _image.comments[index].timeWritten.month
                                            .toString() +
                                        " - " +
                                        _image.comments[index].timeWritten.hour
                                            .toString() +
                                        "h",
                                    style: const TextStyle(
                                        color: const Color(0xff9b9b9b),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Roboto",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12.0)),
                                SizedBox(
                                  width: 20.0 *
                                      (MediaQuery.of(context).size.width /
                                          375.0),
                                ),
                                Text(
                                  _image.comments[index].writter,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: const Color(0xff4a4a4a),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Roboto",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xfffafcff),
      key: _drawerKey,
      appBar: _wImageAppBar,
      drawer: _wDrawer,
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 5.0,
              child: Image.file(File(_image.file)),
            ),
            SizedBox(
              height: 10.0,
            ),
            _wCommentTextInput,
            SizedBox(
              height: 5.0,
            ),
            _wPerksExpand
          ],
        ),
      ),
    );
  }
}
