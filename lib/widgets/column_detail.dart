import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/widgets/small_text.dart';

import '../utils/dimension.dart';
import '../utils/colors.dart';
import 'big_text.dart';
import 'icon_and_text.dart';
// AppColumn
class ColumnDetail extends StatelessWidget {
  final String textName;
  const ColumnDetail({super.key, required this.textName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(text: textName, size: Dimension.font_size26,),
        SizedBox(height: Dimension.height10,),
        Row(
          children: [
            Wrap(
              children: List.generate(5, (index) {return Icon(Icons.star, color:AppColors.mainColor,size: Dimension.icon15,);}),
            ),
            SizedBox(width: Dimension.height10,),
            SmallText(text: "4.5"),
            SizedBox(width: Dimension.height10,),
            SmallText(text: "1000"),
            SizedBox(width: Dimension.height10,),
            SmallText(text: "Comments"),
          ],
        ),
        SizedBox(height: Dimension.height20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndText(iconData: Icons.circle_sharp, text: "Nomarl", iconColor: AppColors.iconColor1),
            IconAndText(iconData: Icons.location_on, text: "1.5km", iconColor: AppColors.mainColor),
            IconAndText(iconData: Icons.access_time, text: "32min", iconColor: AppColors.iconColor1)

          ],
        )
      ],
    );
  }
}
