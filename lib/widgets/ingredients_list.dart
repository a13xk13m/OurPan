import 'package:flutter/material.dart';

import 'package:our_pan/res/custom_colors.dart';

// Model to represent an item in the Grocery List.
class IngredientModel {
  String name;
  num amount;
  String unit;

  IngredientModel(
      {this.name = 'Ingredient', this.amount = 0, this.unit = 'Units'});

  IngredientModel.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'] as String,
        amount = json['amount'] as num,
        unit = json['unit'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'name': name,
        'amount': amount,
        'unit': unit,
      };

  bool equals(IngredientModel i) {
    return (name == i.name && amount == i.amount && unit == i.unit);
  }
}

// Grocery List Item Model
class IngredientCard extends StatefulWidget {
  IngredientModel ing;
  int index;
  Function deleteFunc;
  Function updateFunc;
  bool editable;

  IngredientCard(
      {required Key key,
      required this.ing,
      required this.index,
      required this.updateFunc,
      required this.deleteFunc,
      this.editable = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IngredientCardState();
  }
}

class _IngredientCardState extends State<IngredientCard> {
  late String name;
  late num amount;
  late String unit;
  late IngredientModel ing;
  late Function deleteFunc;
  late Function updateFunc;
  late int index;
  late TextEditingController nameCon;
  late TextEditingController amountCon;
  late TextEditingController unitCon;
  bool editMode = false;
  late bool editable;

  @override
  void initState() {
    ing = widget.ing;
    name = ing.name;
    amount = ing.amount;
    unit = ing.unit;
    deleteFunc = widget.deleteFunc;
    updateFunc = widget.updateFunc;
    index = widget.index;
    editable = widget.editable;
    nameCon = TextEditingController(text: name);
    amountCon = TextEditingController(text: amount.toString());
    unitCon = TextEditingController(text: unit);
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
                  style: TextStyle(fontSize: 20),
                  controller: nameCon,
                ))
              : Text(
                  name,
                  style: TextStyle(fontSize: 24, color: CustomColors.darkText),
                ),
          SizedBox(width: 20),
          editMode
              ? Row(children: [
                  Expanded(
                      child: TextField(
                    style: TextStyle(fontSize: 18),
                    controller: amountCon,
                  )),
                  SizedBox(width: 5)
                ])
              : Text(
                  amount.toString(),
                  style: TextStyle(fontSize: 20, color: CustomColors.lightText),
                ),
          editMode
              ? Expanded(
                  child: TextField(
                  style: TextStyle(fontSize: 18),
                  controller: unitCon,
                ))
              : Text(
                  " $unit",
                  style: TextStyle(fontSize: 20, color: CustomColors.lightText),
                ),
          Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            editable
                ? editMode
                    ? IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          setState(() {
                            ing = IngredientModel(
                                name: nameCon.text,
                                amount: num.parse(amountCon.text),
                                unit: unitCon.text);
                            name = ing.name;
                            unit = ing.unit;
                            amount = ing.amount;
                            editMode = false;
                          });
                          updateFunc(index, ing);
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
                      deleteFunc(ing);
                    },
                    splashRadius: 15,
                  )
                // Height of resized box is 3 * 15, the splash radius of the
                // above multiplied by 3.s
                : SizedBox(height: 45),
          ]))
        ],
      ),
    ));
  }
}

class IngredientsList extends StatefulWidget {
  late List<IngredientModel> ingredients;
  late bool editable;
  IngredientsList({required this.ingredients, this.editable = true});

  @override
  State<StatefulWidget> createState() {
    return _IngredientsListState();
  }
}

class _IngredientsListState extends State<IngredientsList> {
  late List<IngredientModel> l;
  late bool editable;

  void initState() {
    super.initState();
    editable = widget.editable;
    l = widget.ingredients;
  }

  // Updates the list based on new ingredient
  void ingUpdateFunc(int index, IngredientModel ing) {
    setState(() {
      l[index] = ing;
    });
  }

  // Deletes an ingredient from the list by ingredient.
  void ingDeleteFunc(IngredientModel ing) {
    for (int i = 0; i < l.length; ++i) {
      if (l[i].equals(ing)) {
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
          IngredientCard(
            key: Key(l[i].hashCode.toString()),
            ing: l[i],
            index: i,
            updateFunc: ingUpdateFunc,
            deleteFunc: ingDeleteFunc,
            editable: editable,
          ),
        editable
            ? IconButton(
                onPressed: () {
                  setState(() {
                    l.add(IngredientModel());
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
