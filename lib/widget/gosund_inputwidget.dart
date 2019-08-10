import 'package:flutter/material.dart';
/**
 *
 * Project Name: SkyRoad
 * Package Name: widget
 * File Name: gosund_inputwidget
 * USER: Aige
 * Create Time: 2019-07-31-10:22
 *
 */

class GosundInputWidget extends StatefulWidget {
  final bool obsecureText;

  final String hintText;
  final IconData iconData;
  final ValueChanged<String> onChanged;

  final TextStyle textStyle;

  final TextEditingController controller;

  GosundInputWidget(
      {Key key,
      this.obsecureText = false,
      this.hintText,
      this.iconData,
      this.onChanged,
      this.textStyle,
      this.controller});

  @override
  GosundInputWidgetState createState() => GosundInputWidgetState();
}

class GosundInputWidgetState extends State<GosundInputWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        child: TextField(
          maxLength: 40,
          minLines: 1,
          autocorrect: true,
          style: TextStyle(fontSize: 14, color: Colors.blue),
          textAlign: TextAlign.left,
          obscureText: widget.obsecureText,
          onChanged: widget.onChanged,
          controller: widget.controller,
          autofocus: true,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              hintText: widget.hintText,
              fillColor: Colors.blue.shade100,
              suffixIcon:
                  widget.iconData == null ? null : Icon(widget.iconData),
//          labelText: 'username',
//          filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              prefixIcon:
                  widget.iconData == null ? null : Icon(widget.iconData)),

//          icon: widget.iconData == null ? null : Icon(widget.iconData)),
        ),
      ),
    );
  }
}
