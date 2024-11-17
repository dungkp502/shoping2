import 'package:flutter/cupertino.dart';
import 'package:food_app/widgets/small_text.dart';
import '../utils/dimension.dart';

class IconAndText extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color iconColor;

  const IconAndText({super.key, required this.iconData, required this.text, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData, color: iconColor, size: Dimension.icon24,),
        SizedBox(width: 1,),
        SmallText(text: text,)
      ],
    );
  }
}
