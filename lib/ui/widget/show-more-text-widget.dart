import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ShowMoreWidget extends StatefulWidget {
  final String text;
  final int length;

  ShowMoreWidget({required this.text, required this.length});

  @override
  _ShowMoreWidgetState createState() => new _ShowMoreWidgetState();
}

class _ShowMoreWidgetState extends State<ShowMoreWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > widget.length) {
      firstHalf = widget.text.substring(0, widget.length);
      secondHalf = widget.text.substring(widget.length, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      // padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? new Html(data: firstHalf)
          : new Column(
              children: <Widget>[
                new Html(
                    data: flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                    style: {
                      "body": Style(
                          fontSize: FontSize(FontSizes.body),
                          fontWeight: FontWeight.w300,
                          fontFamily: Fonts.body),
                    }),
                new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        flag ? "show more" : "show less",
                        style: new TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
