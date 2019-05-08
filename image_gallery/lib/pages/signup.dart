import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helping_scripts/handlers/click_handler.dart';
import '../helping_scripts/handlers/prefs_handler.dart';
import '../helping_scripts/handlers/request_handler.dart';
import '../cache/domain_cache.dart';
import '../CONSTANTS/constant_routes.dart';

import '../pages/login.dart';
import '../pages/gallery.dart';

import '../model/user.dart';

class Signup extends StatefulWidget {
  @override
  SingupState createState() => new SingupState();
}

class SingupState extends State<Signup> {
  String _errorText = "";
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;
  bool _errors = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordController2 = TextEditingController();
  final _jsonCodec = const JsonCodec();

  var _nodeEmail = new FocusNode();
  var _nodePass = new FocusNode();
  var _nodePassConf = new FocusNode();

  bool _onFocusEmail = false;
  bool _onFocusPass = false;
  bool _onFocusPassConf = false;
  bool _canAnimateLoad = false;

  ClickHandler _click;
  PrefsHandler _prefs;

  SingupState() {
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

    _nodePassConf.addListener(() {
      setState(() {
        _onFocusPassConf = _nodePassConf.hasFocus;
      });

      if (_nodePassConf.hasFocus) {
        _removeAlerts();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
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

  void _onChangedObscure2() {
    setState(() {
      _obscurePassword2 = !_obscurePassword2;
    });
  }

  void _onChangedLoad(bool value) {
    setState(() {
      _canAnimateLoad = value;
    });
  }

  void routeToLogIn() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  Future<bool> closeApp() async {
    exit(0);

    return true;
  }

  Future<String> submitSignUp() async {
    _removeAlerts();

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

    if (_passwordController.text != _passwordController2.text) {
      _click.unlock();
      _showAlert("Passwords do not match");
      return "Passwords do not match";
    }

    _onChangedLoad(true);

    User user = new User(_emailController.text, _passwordController.text);

    var json = _jsonCodec.encode(user);

    http.Response responseSignup = await RequestHandler.executePostRequest(
        ConstantRoutes.getUser, json);

    if (responseSignup.statusCode != 200 && responseSignup.statusCode != 201) {
      var responseBody = _jsonCodec.decode(responseSignup.body);

      _click.unlock();
      _onChangedLoad(false);
      _showAlert(responseBody["info"][0]["msg"]);
      print(responseBody);
      return responseBody["error"];
    }

    http.Response responseLogIn =
        await RequestHandler.executePostRequest(ConstantRoutes.loginUser, json);

    var responseBody = _jsonCodec.decode(responseLogIn.body);
    print(responseBody);

    if (responseLogIn.statusCode != 200 && responseSignup.statusCode != 201) {
      _click.unlock();
      _onChangedLoad(false);
      _showAlert(responseBody["info"][0]["msg"]);
      print(responseBody);
      return responseBody["error"];
    }

    _prefs.setString("email", _emailController.text);
    _prefs.setBool("logged", true);

    /* --- USED FOR SERVER VERSION ---*/
    // _prefs.setString("uuid", responseBody["info"]["user"]["_id"]);

    DomainCache.user = user;
    // DomainCache.token = responseBody["info"]["token"];

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
                top: 20.0 * (MediaQuery.of(context).size.width / 375.0)),
          ),
        ));

    final passwordConfirm = Theme(
        data: ThemeData(
            cursorColor: Colors.white,
            primaryColor: const Color(0x8effffff),
            accentColor: const Color(0x8effffff),
            canvasColor: const Color(0x8effffff),
            highlightColor: const Color(0x8effffff),
            hintColor: const Color(0x8effffff)),
        child: TextFormField(
          focusNode: _nodePassConf,
          //onEditingComplete: () => _removeAlerts(),
          controller: _passwordController2,
          autofocus: false,
          obscureText: _obscurePassword2,
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
            hintText: _onFocusPassConf ? "" : 'Confirm Password',
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
                onPressed: () => _onChangedObscure2(),
                child: Image.asset(
                  _obscurePassword2
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
                top: 20.0 * (MediaQuery.of(context).size.width / 375.0)),
          ),
        ));

    final signupButton = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: OutlineButton(
                  padding: EdgeInsets.all(
                      10.0 * (MediaQuery.of(context).size.width / 375.0)),
                  child: new Text(
                    "SIGN UP",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            16.0 * (MediaQuery.of(context).size.width / 375.0),
                        letterSpacing:
                            1.5 * (MediaQuery.of(context).size.width / 375.0)),
                  ),
                  color: Colors.lightBlueAccent,
                  onPressed: () => _click.clickActionOnce(submitSignUp),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(
                          30.0 * (MediaQuery.of(context).size.width / 375.0)))))
        ]);

    final logInSwitch = FlatButton(
      child: Text(
        "Already have account? Sign in.",
        style: TextStyle(
            color: const Color(0x8effffff),
            fontWeight: FontWeight.w400,
            fontFamily: "Roboto",
            fontStyle: FontStyle.normal,
            fontSize: 12.0 * (MediaQuery.of(context).size.width / 375.0)),
      ),
      onPressed: () {
        _click.clickActionOnce(routeToLogIn);
      },
    );

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
              logo,
              SizedBox(
                height: 50.0 * (MediaQuery.of(context).size.height / 667.0),
              ),
              email,
              password,
              passwordConfirm,
              SizedBox(
                height: 2.0 * (MediaQuery.of(context).size.height / 667.0),
              ),
              SizedBox(
                height: 44.0 * (MediaQuery.of(context).size.height / 667.0),
              ),
              errorMessage,
              SizedBox(
                height: 20.0 * (MediaQuery.of(context).size.height / 667.0),
              ),
              signupButton,
              SizedBox(
                height: 5.0 * (MediaQuery.of(context).size.height / 667.0),
              ),
              logInSwitch
            ],
          ),
        ),
      )),
    );
  }
}
