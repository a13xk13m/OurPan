import 'package:flutter/material.dart';

import 'package:our_pan/res/custom_colors.dart';

// Model to represent an item in the Grocery List.
class StepModel {
  String text;
  int index;

  StepModel({this.text = 'Step', required this.index});

  StepModel.fromJson(Map<dynamic, dynamic> json)
      : text = json['text'] as String,
        index = json['index'] as int;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'text': text,
        'index': index,
      };

  bool equals(StepModel step) {
    return (text == step.text && index == step.index);
  }
}

// Grocery List Item Model
class StepCard extends StatefulWidget {
  StepModel step;
  int index;
  Function deleteFunc;
  Function updateFunc;
  bool editable;

  StepCard(
      {required Key key,
      required this.step,
      required this.index,
      required this.updateFunc,
      required this.deleteFunc,
      this.editable = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StepCardState();
  }
}

class _StepCardState extends State<StepCard> {
  late String text;
  late int index;
  late StepModel step;
  late Function deleteFunc;
  late Function updateFunc;
  late TextEditingController textCon;
  // editMode is whether text is editable, editable is whether the edit buttons
  // are displayed.
  bool editMode = false;
  late bool editable;

  @override
  void initState() {
    step = widget.step;
    text = step.text;
    index = step.index;
    deleteFunc = widget.deleteFunc;
    updateFunc = widget.updateFunc;
    editable = widget.editable;
    textCon = TextEditingController(text: text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (Card(
      color: CustomColors.bars,
      child: Row(
        children: [
          SizedBox(width: 20),
          editMode
              ? Expanded(
                  child: TextField(
                  minLines: 1,
                  maxLines: 3,
                  style: TextStyle(fontSize: 20),
                  controller: textCon,
                ))
              : Expanded(
                  child: Text(
                  text,
                  style: TextStyle(fontSize: 20, color: CustomColors.darkText),
                )),
          SizedBox(width: 20),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            editable
                ? editMode
                    ? IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          setState(() {
                            step = StepModel(text: textCon.text, index: index);
                            text = step.text;
                            index = step.index;
                            editMode = false;
                          });
                          updateFunc(index, step);
                        },
                        splashRadius: 15,
                      )
                    : IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            editMode = true;
                          });
                        },
                        splashRadius: 15,
                      )
                : SizedBox(),
            editable
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteFunc(step);
                    },
                    splashRadius: 15,
                  )
                : SizedBox(
                    height: 45,
                  ),
          ])
        ],
      ),
    ));
  }
}

class StepList extends StatefulWidget {
  late List<StepModel> steps;
  bool editable = true;
  StepList({required this.steps, this.editable = true});

  @override
  State<StatefulWidget> createState() {
    return _StepListState();
  }
}

class _StepListState extends State<StepList> {
  late List<StepModel> l;
  late bool editable;

  void initState() {
    super.initState();
    l = widget.steps;
    editable = widget.editable;
  }

  // Updates the list based on new Step
  void stepUpdateFunc(int index, StepModel step) {
    setState(() {
      l[index] = step;
    });
  }

  // Deletes an Step from the list by Step.
  void stepDeleteFunc(StepModel step) {
    for (int i = 0; i < l.length; ++i) {
      if (l[i].equals(step)) {
        setState(() {
          l.removeAt(i);
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      children: [
        for (int i = 0; i < l.length; ++i)
          StepCard(
            key: Key(l[i].hashCode.toString()),
            step: l[i],
            index: i,
            updateFunc: stepUpdateFunc,
            deleteFunc: stepDeleteFunc,
            editable: editable,
          ),
        editable
            ? IconButton(
                onPressed: () {
                  setState(() {
                    l.add(StepModel(index: l.length));
                  });
                },
                icon: Icon(
                  Icons.add,
                  color: CustomColors.darkText,
                ))
            : SizedBox(),
      ],
    ));
  }
}
