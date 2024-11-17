import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/widgets/small_text.dart';

class ExtendText extends StatefulWidget {
  final String text;
  const ExtendText({super.key, required this.text});

  @override
  State<ExtendText> createState() => _ExtendTextState();
}

class _ExtendTextState extends State<ExtendText> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;

  double textHeight = Dimension.screenHeight/8.48;

  @override
  void initState() {
    super.initState();
    if(widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt()+1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty?SmallText(height: 1.5, color: AppColors.paraColor, size: Dimension.font_size16 ,text: firstHalf): Column(
        children: [
          SmallText(height: 1.5, color: AppColors.paraColor,size: Dimension.font_size16 ,text: hiddenText?("$firstHalf..."):(firstHalf+secondHalf)),
          InkWell(
            onTap: () {
              setState(() {
                hiddenText = !hiddenText;
              });
            },
            child: Row(
              children: [
                SmallText(text: "Show more", color: AppColors.mainColor,),
                Icon(hiddenText?Icons.arrow_drop_down:Icons.arrow_drop_up, color: AppColors.mainColor,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
