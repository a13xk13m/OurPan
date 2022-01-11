import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';

class RecipeInteractRibbon extends StatefulWidget {
  late bool liked;
  RecipeInteractRibbon({this.liked = false});

  @override
  State<StatefulWidget> createState() {
    return _RecipeInteractRibbonState();
  }
}

class _RecipeInteractRibbonState extends State<RecipeInteractRibbon> {
  late bool liked;

  @override
  void initState() {
    liked = widget.liked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            Icons.thumb_up_sharp,
            color: liked ? CustomColors.lightText : CustomColors.darkText,
          ),
          onPressed: () {
            setState() {
              liked = !liked;
              print(liked);
            }
            // TODO: Add like and unlike functionality.
          },
        ),
        IconButton(
            icon: Icon(
              Icons.comment,
              color: CustomColors.darkText,
            ),
            onPressed: () {
              // TODO: Add comment functionality.
            }),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: CustomColors.darkText,
          ),
          onPressed: () {
            // TODO: Add more dropdown menu.
          },
        )
      ],
    );
  }
}
