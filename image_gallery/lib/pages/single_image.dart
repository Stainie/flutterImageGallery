import 'package:flutter/material.dart';

import '../model/gallery_image.dart';
import '../model/comment.dart';

class SingleImage extends StatefulWidget {
  final GalleryImage _image;

  SingleImage(this._image);

  @override
  SingleImageState createState() => new SingleImageState(_image);
}

class SingleImageState extends State<SingleImage> {
  final GalleryImage _image;

  final _commentController = TextEditingController();

  SingleImageState(this._image);

  void _addComment(String text) {
    setState(() {
      _image.comments.add(new Comment(text, DateTime.now(), "My Profile"));
    });
    _commentController.text = "";
  }

  @override
  Widget build(BuildContext context) {

    Widget _wImageAppBar = AppBar(
      leading: IconButton(
          icon: new Image.asset(
            "assets/burger.png",
            width: 18.0,
            height: 19.0,
          ),
          onPressed: () => {}),
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
                    fontSize: 14.0 * (MediaQuery.of(context).size.width / 375.0)),
                hintText: "Add a comment ...",
                hintStyle: TextStyle(
                    color: const Color(0xff4a4a4a),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0 * (MediaQuery.of(context).size.width / 375.0)),
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
      appBar: _wImageAppBar,
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 5.0,
              child: Image.file(_image.file),
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