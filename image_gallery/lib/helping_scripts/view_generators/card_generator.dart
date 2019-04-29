import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String _data;
  final int _index;
  final dynamic _action;

  CardItem(this._data, this._index, this._action);

  @override
  Widget build(BuildContext context) {
    return new Card(
      margin: EdgeInsets.fromLTRB(
          0.0,
          4.0 * (MediaQuery.of(context).size.width / 375.0),
          0.0,
          4.0 * (MediaQuery.of(context).size.width / 375.0)),
      color: Colors.white,
      elevation: 1.0,
      child: new InkWell(
        onTap: () => _action(_index),
        child: new Container(
          width: 342.0 * (MediaQuery.of(context).size.width / 375.0),
          child: new Padding(
              padding: new EdgeInsets.all(9.0* (MediaQuery.of(context).size.width / 375.0)),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.all(
                        5.0 * (MediaQuery.of(context).size.width / 375.0)),
                    margin: new EdgeInsets.all(
                        2.0 * (MediaQuery.of(context).size.width / 375.0)),
                    child: new Text(_data,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: const Color(0xff4a4a4a),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.7,
                            fontSize: 16.0)),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
