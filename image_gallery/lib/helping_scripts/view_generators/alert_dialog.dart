import 'package:flutter/material.dart';
import './custom_alert.dart';

class AlertWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final dynamic action;
  final String footer;
  final dynamic footerAction;
  final dynamic footerActionParam;

  AlertWidget(this.title, this.subtitle,
      [this.action, this.footer, this.footerAction, this.footerActionParam]);

  @override
  Widget build(BuildContext context) {
    void performAction() {
      Navigator.of(context).pop();
      action();
    }

    return new CustomAlertDialog(
      contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
      content: Container(
        width: 319.0 * (MediaQuery.of(context).size.width / 375.0),
        height: 342.0 * (MediaQuery.of(context).size.width / 375.0),
        decoration: new BoxDecoration(
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                IconButton(
                  alignment: Alignment.topLeft,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    size: 18.0,
                  ),
                ),
                Image.asset(
                  "assets/cgc.png",
                  width: 60.3,
                  height: 69.0,
                ),
                SizedBox(
                  height: 32.0 * (MediaQuery.of(context).size.height / 667.0),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: const Color(0xff4a4a4a),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                ),
                SizedBox(
                  height: 5.0 * (MediaQuery.of(context).size.height / 667.0),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: const Color(0xff4a4a4a),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                ),
                // SizedBox(
                //   height: 16.0 * (MediaQuery.of(context).size.height / 667.0),
                // ),
              ],
            ),
            Positioned(
              width: 280.0 * (MediaQuery.of(context).size.width / 375.0),
              top: MediaQuery.of(context).size.height - 340.0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        width: 111.0 *
                            (MediaQuery.of(context).size.height / 667.0),
                        child: OutlineButton(
                            borderSide:
                                BorderSide(color: const Color(0xff4a4a4a)),
                            splashColor: const Color(0xff4a4a4a),
                            textColor: const Color(0xff4a4a4a),
                            disabledBorderColor: const Color(0xff4a4a4a),
                            highlightedBorderColor: const Color(0xff4a4a4a),
                            padding: EdgeInsets.all(2.0) *
                                (MediaQuery.of(context).size.height / 667.0),
                            child: new Text(
                              "OK",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                            ),
                            color: const Color(0xff4a4a4a),
                            onPressed: () => action != null
                                ? performAction()
                                : Navigator.of(context).pop(),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0 *
                                    (MediaQuery.of(context).size.height /
                                        667.0))))),
                    footerAction != null
                        ? FlatButton(
                            onPressed: () => footerAction(footerActionParam),
                            child: Text(
                              footer,
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: const Color(0xff4a4a4a),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                            ),
                          )
                        : Container()
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
