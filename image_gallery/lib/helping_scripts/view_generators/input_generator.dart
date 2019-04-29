import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputGenerator extends StatelessWidget {
  final FocusNode currentNode;
  final FocusNode nextNode;
  final FocusNode previousNode;
  final TextEditingController controller;

  InputGenerator(
      this.currentNode, this.nextNode, this.previousNode, this.controller);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: 37.0 * (MediaQuery.of(context).size.width / 375.0),
          minHeight: 37.0 * (MediaQuery.of(context).size.width / 375.0),
          minWidth: 35.0 * (MediaQuery.of(context).size.width / 375.0),
          maxWidth: 35.0 * (MediaQuery.of(context).size.width / 375.0)),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: controller.text == ""
                ? const Color(0xb3ffffff).withAlpha(0)
                : const Color(0xb3ffffff),
            border: Border.all(color: const Color(0xb3ffffff))),
        child: Theme(
          data: ThemeData(
              primaryColor: const Color(0x8effffff),
              accentColor: const Color(0x8effffff),
              canvasColor: const Color(0x8effffff),
              highlightColor: const Color(0x8effffff),
              hintColor: const Color(0x8effffff)),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(1)],
            focusNode: currentNode,
            onChanged: (text) => controller.text == ""
                ? FocusScope.of(context).requestFocus(previousNode)
                : FocusScope.of(context).requestFocus(nextNode),
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: false,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: const Color(0xff4a4a4a),
                fontWeight: FontWeight.w700,
                fontFamily: "Poppins",
                fontStyle: FontStyle.normal,
                fontSize: 22.0),
            decoration: InputDecoration(
              border: InputBorder.none,
              labelStyle: TextStyle(
                  color: const Color(0xb3ffffff),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0 * (MediaQuery.of(context).size.width / 375.0)),
              contentPadding: EdgeInsets.all(
                  4.0 * (MediaQuery.of(context).size.width / 375.0)),
            ),
          ),
        ),
      ),
    );
  }
}
