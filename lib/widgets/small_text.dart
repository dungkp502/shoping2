import 'package:flutter/cupertino.dart';

class SmallText extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  double height;
  TextOverflow textOverflow;
  int? maxLines;
  SmallText({super.key, this.color = const Color(0xFF8f837f), required this.text,
    this.textOverflow=TextOverflow.ellipsis,
    this.size=12,
    this.height = 1.2,
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines != null ? textOverflow : null,
      style: TextStyle(
          fontFamily: 'Roboto',
          color: color,
          fontSize: size,
          height: height
          // fontWeight: FontWeight.w400
      ),
    );
  }
}
