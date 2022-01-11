import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/widgets/recipe_interact_ribbon.dart';

// Class represents a tag in the list.
class TagCard extends StatefulWidget {
  final String text;
  final int index;
  final Function deleteFunc;
  final Function editFunc;
  bool edit;
  bool editable = true;
  TagCard(
      {required this.text,
      required this.index,
      required this.deleteFunc,
      required this.editFunc,
      this.edit = false,
      this.editable = true});

  @override
  State<StatefulWidget> createState() {
    return _TagCardState();
  }
}

class _TagCardState extends State<TagCard> {
  late String text;
  late int index;
  late Function deleteFunc;
  late Function editFunc;
  late bool edit;
  late bool editable;
  TextEditingController con = TextEditingController();

  @override
  void initState() {
    super.initState();
    text = widget.text;
    index = widget.index;
    deleteFunc = widget.deleteFunc;
    editFunc = widget.editFunc;
    edit = widget.edit;
    editable = widget.editable;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // TODO: Redirect to tag search results.
        },
        child: Container(
          padding: EdgeInsets.only(left: 15),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: CustomColors.bars,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              edit
                  ? Container(
                      width: 140,
                      child: TextField(
                        maxLength: 15,
                        decoration: const InputDecoration(
                            helperText: "Tag", isDense: true),
                        controller: con,
                      ))
                  : Text(text,
                      style: TextStyle(
                          color: CustomColors.lightText, fontSize: 18)),
              editable
                  ? edit
                      ? IconButton(
                          splashRadius: 10,
                          icon: Icon(
                            Icons.check,
                            color: CustomColors.lightText,
                          ),
                          onPressed: () {
                            if (con.text != '') {
                              setState(() {
                                text = con.text;
                                edit = false;
                              });
                              editFunc(index, text);
                            }
                          },
                        )
                      : IconButton(
                          splashRadius: 10,
                          icon: Icon(
                            Icons.close,
                            color: CustomColors.lightText,
                          ),
                          onPressed: () {
                            deleteFunc(index);
                          },
                        )
                  : SizedBox(
                      height: 40,
                      width: 15,
                    ),
            ],
          ),
        ));
  }
}

// Field that allows for the creation and deletion of tags to add to item.
class TagField extends StatefulWidget {
  List<String> tags;
  int limit;
  bool editable;

  TagField({required this.tags, required this.limit, required this.editable});

  @override
  State<StatefulWidget> createState() {
    return _TagFieldState();
  }
}

class _TagFieldState extends State<TagField> {
  late List<String> tags;
  late int limit;
  late bool editable;

  void initState() {
    super.initState();
    tags = widget.tags;
    limit = widget.limit;
    editable = widget.editable;
  }

  // Deletes a tag by index from list of tags.
  void deleteTagFunc(int index) {
    setState(() {
      tags.removeAt(index);
    });
  }

  // Updates a tag by index.
  void editTagFunc(int index, String text) {
    tags[index] = text;
  }

  @override
  Widget build(BuildContext context) {
    return (Column(children: [
      Text(
        'Add up to 10 tags',
        style: TextStyle(color: CustomColors.lightText, fontSize: 18),
      ),
      Wrap(
        children: [
          for (var i = 0; i < tags.length; ++i)
            i == tags.length - 1 && editable
                ? TagCard(
                    text: tags[i],
                    index: i,
                    deleteFunc: deleteTagFunc,
                    editFunc: editTagFunc,
                    edit: true,
                    editable: editable)
                : TagCard(
                    text: tags[i],
                    index: i,
                    deleteFunc: deleteTagFunc,
                    editFunc: editTagFunc,
                    edit: false,
                    editable: editable),
          editable
              ? tags.length > limit
                  ? Text('Maximum number of tags reached',
                      style: TextStyle(color: CustomColors.darkText))
                  : IconButton(
                      icon: Icon(
                        Icons.add,
                        color: CustomColors.darkText,
                      ),
                      onPressed: () {
                        setState(() {
                          tags.add('');
                        });
                      },
                    )
              : SizedBox(),
        ],
      )
    ]));
  }
}
