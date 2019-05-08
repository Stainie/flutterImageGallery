import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helping_scripts/handlers/click_handler.dart';
import '../helping_scripts/handlers/prefs_handler.dart';
import '../helping_scripts/handlers/request_handler.dart';
import '../cache/domain_cache.dart';
import '../CONSTANTS/constant_routes.dart';

import '../pages/signup.dart';
import '../pages/gallery.dart';

import '../model/gallery_image.dart';
import '../model/user.dart';
import '../model/comment.dart';
import '../model/gallery_image_server.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<Login> {
  bool _obscurePassword = true;
  bool _canAnimateLoad = false;
  bool _errors = false;
  String _errorText = "";

  ClickHandler _click;
  PrefsHandler _prefs;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _jsonCodec = const JsonCodec();

  var _nodeEmail = new FocusNode();
  var _nodePass = new FocusNode();

  bool _onFocusEmail = false;
  bool _onFocusPass = false;

  LoginState() {
    _click = new ClickHandler();
    _prefs = new PrefsHandler();
  }

  @override
  void initState() {
    super.initState();
    _nodeEmail.addListener(() {
      setState(() {
        _onFocusEmail = _nodeEmail.hasFocus;
      });

      if (_nodeEmail.hasFocus) {
        _removeAlerts();
      }
    });

    _nodePass.addListener(() {
      setState(() {
        _onFocusPass = _nodePass.hasFocus;
      });

      if (_nodePass.hasFocus) {
        _removeAlerts();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showAlert(String text) {
    setState(() {
      _errors = true;
      _errorText = text;
    });
  }

  void _removeAlerts() {
    setState(() {
      _errors = false;
      _errorText = "";
    });
  }

  void _onChangedObscure() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _onChangedLoad(bool value) {
    setState(() {
      _canAnimateLoad = value;
    });
  }

  void routeToSignUp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
  }

  Future<bool> closeApp() async {
    exit(0);

    return true;
  }

  Future<String> submitLogIn() async {
    if (_emailController.text.isEmpty) {
      _click.unlock();
      _showAlert("Email is required");
      return "Email is required";
    }

    if (_passwordController.text.isEmpty) {
      _click.unlock();
      _showAlert("Password is required");
      return "Password is required";
    }

    _removeAlerts();

    _onChangedLoad(true);

    User user = new User(_emailController.text, _passwordController.text);

    var json = _jsonCodec.encode(user);

    http.Response responseLogIn =
        await RequestHandler.executePostRequest(ConstantRoutes.loginUser, json);

    var responseBody = _jsonCodec.decode(responseLogIn.body);
    print(responseBody);

    if (responseLogIn.statusCode != 200) {
      _click.unlock();
      _onChangedLoad(false);
      _showAlert(responseBody["info"][0]["msg"]);
      print(responseBody["error"]);
      return responseBody["error"];
    }

    _prefs.setString("email", _emailController.text);
    _prefs.setBool("logged", true);
    DomainCache.user = user;
    // DomainCache.token = responseBody["info"]["token"];

    /* --- USED FOR SERVER VERSION ---*/

    /* _prefs.setString("uuid", responseBody["info"]["user"]["_id"]);
    http.Response responseImages = await RequestHandler.executeGetRequest(
        ConstantRoutes.getImages + _prefs.getString("uuid"));

    var responseData = _jsonCodec.decode(responseImages.body);

    List<GalleryImageServer> images = new List<GalleryImageServer>();

    List imagesBody = responseData["info"];

    for (var i = 0; i < imagesBody.length; i++) {
      GalleryImageServer img = new GalleryImageServer(
          imagesBody[i]["title"], imagesBody[i]["imageUrl"]);
      img.setUuid(imagesBody[i]["uuid"]);

      http.Response responseComments = await RequestHandler.executeGetRequest(
          ConstantRoutes.getComments + img.uuid);
      var responseDataComments = _jsonCodec.decode(responseComments.body);
      List commentsBody = responseDataComments["info"];

      for (var j = 0; j < commentsBody.length; j++) {
        img.comments.add(new Comment(commentsBody[j]["text"],
            commentsBody[j]["timeWritten"], commentsBody[j]["writter"]));
      }

      images.add(img);
    }

    DomainCache.galleryImagesServer = images; */

    List<GalleryImage> images = new List<GalleryImage>();
    List decodedImages = _prefs.getString("images") != null
        ? _jsonCodec.decode(_prefs.getString("images"))
        : null;

    if (decodedImages != null) {
      for (var i = 0; i < decodedImages.length; i++) {
        List<Comment> comments = new List<Comment>();
        List decodedCommens = decodedImages[i]["comments"];

        for (var j = 0; j < decodedCommens.length; j++) {
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
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'logo',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 64.0 * (MediaQuery.of(context).size.width / 375.0),
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = Theme(
        data: ThemeData(
            cursorColor: Colors.white,
            primaryColor: const Color(0x8effffff),
            accentColor: const Color(0x8effffff),
            canvasColor: const Color(0x8effffff),
            highlightColor: const Color(0x8effffff),
            hintColor: const Color(0x8effffff)),
        child: TextField(
            focusNode: _nodeEmail,
            //onEditingComplete: () => _removeAlerts(),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            style: TextStyle(
                letterSpacing:
                    1.0 * (MediaQuery.of(context).size.width / 375.0),
                color: const Color(0xb3ffffff),
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
                fontStyle: FontStyle.normal,
                fontSize: 14.0 * (MediaQuery.of(context).size.width / 375.0)),
            decoration: InputDecoration(
              helperStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(
                  color: const Color(0xb3ffffff),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0 * (MediaQuery.of(context).size.width / 375.0)),
              hintText: _onFocusEmail ? "" : 'Email',
              hintStyle: TextStyle(
                  color: const Color(0xb3ffffff),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0 * (MediaQuery.of(context).size.width / 375.0)),
              // prefixIcon: Image.asset(
              //   "assets/email.png",
              //   scale: 3.0 * (MediaQuery.of(context).size.width / 375.0),
              // ),
              suffixIcon: FlatButton(
                  padding: EdgeInsets.only(
                      left: 50.0 * (MediaQuery.of(context).size.width / 375.0)),
                  onPressed: () => {},
                  child: Icon(
                    Icons.email,
                    color: const Color(0xb3ffffff),
                  )),
              icon: _errors
                  ? Icon(
                      Icons.error,
                      color: Colors.red[400],
                    )
                  : null,
              contentPadding: EdgeInsets.only(
                  top: 15.0 * (MediaQuery.of(context).size.width / 375.0)),
            )));

    final password = Theme(
        data: ThemeData(
            cursorColor: Colors.white,
            primaryColor: const Color(0x8effffff),
            accentColor: const Color(0x8effffff),
            canvasColor: const Color(0x8effffff),
            highlightColor: const Color(0x8effffff),
            hintColor: const Color(0x8effffff)),
        child: TextFormField(
          focusNode: _nodePass,
          //onEditingComplete: () => _removeAlerts(),
          controller: _passwordController,
          autofocus: false,
          obscureText: _obscurePassword,
          style: TextStyle(
              letterSpacing: 1.0 * (MediaQuery.of(context).size.width / 375.0),
              color: const Color(0xb3ffffff),
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
              fontStyle: FontStyle.normal,
              fontSize: 14.0 * (MediaQuery.of(context).size.width / 375.0)),
          decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: const Color(0xb3ffffff),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0 * (MediaQuery.of(context).size.width / 375.0)),
              hintText: _onFocusPass ? "" : 'Password',
              hintStyle: TextStyle(
                  color: const Color(0xb3ffffff),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0 * (MediaQuery.of(context).size.width / 375.0)),
              // prefixIcon: Image.asset(
              //   "assets/password.png",
              //   scale: 3.0 * (MediaQuery.of(context).size.width / 375.0),
              // ),
              suffixIcon: FlatButton(
                  padding: EdgeInsets.only(
                      left: 50.0 * (MediaQuery.of(context).size.width / 375.0)),
                  onPressed: () => _onChangedObscure(),
                  child: Image.asset(
                    _obscurePassword
                        ? "assets/visibility_off.png"
                        : "assets/visibility_on.png",
                    scale: 2.8 * (MediaQuery.of(context).size.width / 375.0),
                  )),
              icon: _errors
                  ? Icon(
                      Icons.error,
                      color: Colors.red[400],
                    )
                  : null,
              contentPadding: EdgeInsets.only(
                  top: 20.0 * (MediaQuery.of(context).size.width / 375.0))),
        ));

    final loginButton = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.43 *
                  (MediaQuery.of(context).size.width / 375.0),
              child: OutlineButton(
                  padding: EdgeInsets.all(
                      10.0 * (MediaQuery.of(context).size.width / 375.0)),
                  child: _canAnimateLoad
                      ? Center(
                          child: SizedBox(
                          height: 20.0 *
                              (MediaQuery.of(context).size.width / 375.0),
                          width: 20.0 *
                              (MediaQuery.of(context).size.width / 375.0),
                          child: new CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2.0 *
                                (MediaQuery.of(context).size.width / 375.0),
                          ),
                        ))
                      : new Text(
                          "LOG IN",
                          style: TextStyle(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.5 *
                                  (MediaQuery.of(context).size.width / 375.0),
                              fontSize: 16.0 *
                                  (MediaQuery.of(context).size.width / 375.0)),
                        ),
                  color: Colors.lightBlueAccent,
                  onPressed: () => _click.clickActionOnce(submitLogIn),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(
                          30.0 * (MediaQuery.of(context).size.width / 375.0)))))
        ]);
    // );

    final signUpSwitch = FlatButton(
        child: Text(
          "Don't have an account? Sign up.",
          style: TextStyle(
              color: const Color(0x8effffff),
              fontWeight: FontWeight.w400,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
              fontSize: 12.0 * (MediaQuery.of(context).size.width / 375.0)),
        ),
        onPressed: () {
          _click.clickActionOnce(routeToSignUp);
        });

    final errorMessage = Text(
      "$_errorText",
      style: TextStyle(
        color: Colors.red[600],
        fontWeight: FontWeight.w400,
        fontFamily: "Poppins",
      ),
      textAlign: TextAlign.center,
    );

    return WillPopScope(
      onWillPop: () async => closeApp(),
      child: Scaffold(
          body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff17ead9), Color(0xff6078ea)])),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                left: 36.5 * (MediaQuery.of(context).size.width / 375.0),
                right: 36.5 * (MediaQuery.of(context).size.width / 375.0)),
            children: <Widget>[
              SizedBox(
                height: 83.0 * (MediaQuery.of(context).size.height / 667.0),
              ),
              (_onFocusEmail || _onFocusPass) ? Container() : logo,
              SizedBox(
                height: 50.0 * (MediaQuery.of(context).size.height / 667.0),
              ),
              email,
              password,
              SizedBox(
                height: 44.0 * (MediaQuery.of(context).size.height / 667.0),
              ),
              errorMessage,
              SizedBox(
                height: 20.0 * (MediaQuery.of(context).size.height / 667.0),
              ),
              loginButton,
              SizedBox(
                height: 5.0 * (MediaQuery.of(context).size.height / 667.0),
              ),
              signUpSwitch,
            ],
          ),
        ),
      )),
    );
  }
}
