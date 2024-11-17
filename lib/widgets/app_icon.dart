import 'package:flutter/cupertino.dart';
import 'package:food_app/utils/dimension.dart';

class AppIcon extends StatelessWidget {
  final IconData iconData;
  final Color colorBackGroundColor;
  final Color color;
  final double size;
  final double iconSize;
  const AppIcon({super.key, required this.iconData, this.colorBackGroundColor = const Color(0xFFfcf4e4), this.color = const Color(0xFF5c524f), this.size = 35, this.iconSize= 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size/2),
        color: colorBackGroundColor
      ),
      child: Icon(iconData, color: color, size: iconSize,),
    );
  }
}
