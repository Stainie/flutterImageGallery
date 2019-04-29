import 'dart:async';
import 'package:flutter/material.dart';

// Create by Arief Setiyo Nugroho <ayiexz22@gmail.com>
// https://github.com/ayiexz/flutter-simple-carousel

class SimpleCarousel extends StatefulWidget {
  SimpleCarousel({
    this.alignment = MainAxisAlignment.end,
    this.animationCurve = Curves.ease,
    this.animationDuration = const Duration(milliseconds: 300),
    this.autoplay = true,
    this.autoplayDuration = const Duration(seconds: 3),
    this.arrow = false,
    this.backgroundLink = Colors.white70,
    this.backgroundTitle = Colors.white70,
    this.backgroundArrow = Colors.white70,
    this.direction = Axis.horizontal,
    this.fit = BoxFit.fill,
    this.fontColorLink = Colors.black,
    this.fontColorTitle = Colors.black,
    this.height = 100.0,
    this.images,
    this.links,
    this.titles,
    this.answers,
    this.descs,
    this.visibleLink = true,
    this.visibleDesc = true,
  });

  final MainAxisAlignment alignment;
  final Curve animationCurve;
  final Duration animationDuration;
  final bool autoplay;
  final bool arrow;
  final Duration autoplayDuration;
  final Color backgroundTitle;
  final Color backgroundLink;
  final Color backgroundArrow;
  final Color fontColorTitle;
  final Color fontColorLink;
  final List<String> images;
  final List<String> links;
  final List<String> titles;
  final List<String> answers;
  final List<String> descs;
  final Axis direction;
  final double height;
  final BoxFit fit;
  final visibleDesc;
  final visibleLink;

  @override
  _SimpleCarouselState createState() => _SimpleCarouselState();
}

class _SimpleCarouselState extends State<SimpleCarousel> {
  PageController _ctrlPage =
      new PageController(initialPage: 999, keepPage: true);
  int _imageIndex = 999;

  @override
  void initState() {
    PageStorageKey(_ctrlPage);
    super.initState();
    autoplay();
  }

  autoplay() {
    if (widget.autoplay) {
      new Timer.periodic(widget.autoplayDuration, (_) {
        _ctrlPage.nextPage(
            duration: widget.animationDuration, curve: widget.animationCurve);
      });
    }
  }

  void _dialogImageTap(int index, [String title = '', String link = '']) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
                content: new Container(
              height: 50.0,
              child: new Column(
                children: <Widget>[
                  title != '' ? new Text("Title : " + title) : null,
                  link != '' ? new Text("Link : " + link) : null,
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> getDots() {
      List<Widget> dots = new List<Widget>();

      for (var i = 0; i < widget.images.length; i++) {
        dots.add(Padding(
          padding: EdgeInsets.all(3.0),
          child: CircleAvatar(
            radius: 4.0,
            foregroundColor: i == _imageIndex % 2
                ? const Color(0xff00c9d2)
                : const Color(0xffd8d8d8),
            backgroundColor: i == _imageIndex % 2
                ? const Color(0xff00c9d2)
                : const Color(0xffd8d8d8),
          ),
        ));
      }

      return dots;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Stack(
          children: <Widget>[
            new Container(
              height: widget.height,
              child: new GestureDetector(
                onTap: () {
                  int index = _imageIndex % widget.links.length;
                  String title =
                      widget.descs[_imageIndex % widget.descs.length];
                  String link = widget.links[_imageIndex % widget.links.length];

                  _dialogImageTap(index, title, link);
                },
                child: new PageView.builder(
                  scrollDirection: widget.direction,
                  controller: _ctrlPage,
                  onPageChanged: (int index) {
                    setState(() {
                      _imageIndex = index.floor();
                    });
                  },
                  key: new PageStorageKey(_ctrlPage),
                  itemBuilder: (context, index) {
                    return new Stack(
                      children: <Widget>[
                        new Center(
                          child: new CircularProgressIndicator(),
                        ),
                        new Center(
                            child: Card(
                          elevation: 1.0,
                          child: new Image.asset(
                            widget.images[index % widget.images.length],
                            fit: widget.fit,
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                          ),
                        )),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 170.0, left: 20.0, right: 20.0),
                            child: Text(
                              widget.titles[index % widget.descs.length],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: const Color(0xff4a4a4a),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 17.0),
                            ),
                          ),
                        ),
                        Center(
                            child: Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Text(
                              widget.answers[index % widget.descs.length],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: const Color(0xff4a4a4a),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Poppins",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 39.0)),
                        )),
                        new Column(
                          mainAxisAlignment: widget.alignment,
                          children: <Widget>[
                            widget.arrow == true
                                ? new Arrow(
                                    background: Colors.black,
                                    height: widget.height,
                                    previous: () {
                                      _ctrlPage.previousPage(
                                          curve: Curves.fastOutSlowIn,
                                          duration:
                                              Duration(milliseconds: 1000));
                                    },
                                    next: () {
                                      _ctrlPage.nextPage(
                                          curve: Curves.fastOutSlowIn,
                                          duration:
                                              Duration(milliseconds: 1000));
                                    },
                                  )
                                : new Container(),
                            new Container(
                              padding:
                                  new EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  widget.visibleDesc
                                      ? Text(
                                          widget.descs[
                                              index % widget.descs.length],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: const Color(0xff4a4a4a),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0),
                                        )
                                      : new Container(),
                                  widget.visibleLink
                                      ? LinkImage(
                                          bgLink: widget.backgroundLink,
                                          index: _imageIndex,
                                          link: widget.links[
                                              index % widget.links.length],
                                          title: widget.descs[
                                              index % widget.descs.length],
                                          onTap: () {
                                            _dialogImageTap(
                                                _imageIndex %
                                                    widget.links.length,
                                                widget.descs[_imageIndex %
                                                    widget.descs.length],
                                                "Button to " +
                                                    widget.links[_imageIndex %
                                                        widget.links.length]);
                                          },
                                          fontColor: widget.fontColorLink,
                                        )
                                      : new Container(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getDots())
      ],
    );
  }
}

class TitleImage extends StatelessWidget {
  TitleImage({this.bgTitle, this.fontColor, this.title});
  final Color bgTitle;
  final Color fontColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: bgTitle,
      padding: new EdgeInsets.only(left: 10.0, right: 10.0),
      child: new Text(title,
          style: new TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold, color: fontColor)),
    );
  }
}

class LinkImage extends StatelessWidget {
  LinkImage(
      {this.index,
      this.bgLink,
      this.fontColor,
      this.link,
      this.onTap,
      this.title});
  final int index;
  final Color bgLink;
  final Color fontColor;
  final String link;
  final Function onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        child: new Container(
          color: bgLink,
          padding: new EdgeInsets.only(left: 10.0),
          child: new Row(
            children: <Widget>[
              new Text(
                "Visit",
                style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: fontColor),
              ),
              new Icon(
                Icons.arrow_right,
                color: fontColor,
              )
            ],
          ),
        ),
        onTap: onTap);
  }
}

class Arrow extends StatelessWidget {
  Arrow({
    @required this.height,
    @required this.background,
    @required this.previous,
    @required this.next,
  });

  final double height;
  final Color background;
  final Function previous;
  final Function next;

  @override
  Widget build(BuildContext context) {
    return new Container(
      //margin: new EdgeInsets.only(bottom: height / 3.8),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new FlatButton(
            child: new Icon(
              Icons.arrow_back_ios,
              size: 17.0,
              color: background,
            ),
            onPressed: previous,
          ),
          new FlatButton(
            child: new Icon(
              Icons.arrow_forward_ios,
              size: 17.0,
              color: background,
            ),
            onPressed: next,
          ),
        ],
      ),
    );
  }
}
