import 'package:flutter/cupertino.dart';

import '../utils/dimension.dart';

class BigText extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  TextOverflow textOverflow;
  BigText({super.key, this.color = const Color(0xFF332d2b), required this.text,
    this.textOverflow=TextOverflow.ellipsis,
    this.size=0
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: textOverflow,
      style: TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontSize: size==0?Dimension.font_size20:size,
        fontWeight: FontWeight.w400
      ),
    );
  }
}
