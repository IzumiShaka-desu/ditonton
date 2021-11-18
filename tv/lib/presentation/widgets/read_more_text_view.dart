import 'package:core/core.dart';
import 'package:flutter/material.dart';

class ReadMoreTextView extends StatefulWidget {
  const ReadMoreTextView({
    Key? key,
    required this.text,
    this.maxCharacter = 50,
  }) : super(key: key);
  final String text;
  final int maxCharacter;
  @override
  State<ReadMoreTextView> createState() => _ReadMoreTextViewState();
}

class _ReadMoreTextViewState extends State<ReadMoreTextView> {
  bool isFolded = true;
  String get chunkedText {
    if (isFolded && widget.text.length > widget.maxCharacter) {
      return widget.text.substring(0, widget.maxCharacter) + "...";
    }
    return widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Text(
          chunkedText,
          style: kBodyText,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isFolded = !isFolded;
            });
          },
          child: Text(isFolded ? "show more" : "show less"),
        )
      ],
    );
  }
}
