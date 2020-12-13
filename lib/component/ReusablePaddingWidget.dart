import 'package:flutter/material.dart';

class ReusablePaddingWidget extends StatelessWidget {
  ReusablePaddingWidget(
      {@required this.color, @required this.onpressed, @required this.title});

  final Function onpressed;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white
            ),
          ),

        ),
      ),
    );
  }
}

