import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/screens/grocery_list_screen.dart';

// Model to represent an item in the Grocery List.
class GroceryListItemModel {
  String name;
  num amount;
  String unit;

  GroceryListItemModel(
      {required this.name, required this.amount, required this.unit});

  GroceryListItemModel.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'] as String,
        amount = json['amount'] as num,
        unit = json['unit'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'name': name,
        'amount': amount,
        'unit': unit,
      };

  bool equals(GroceryListItemModel i) {
    return (name == i.name && amount == i.amount && unit == i.unit);
  }
}

// Grocery List Item Model
class GroceryListItem extends StatefulWidget {
  int index;
  String name;
  num amount;
  String unit;
  GroceryListModel listModel;
  Key key;

  GroceryListItem(
      {required this.key,
      required this.index,
      required this.name,
      required this.amount,
      required this.unit,
      required this.listModel})
      : super(key: key);

  _GroceryListItemState createState() => _GroceryListItemState();
}

class _GroceryListItemState extends State<GroceryListItem> {
  late int index;
  late String name;
  late num amount;
  late String unit;
  late GroceryListModel listModel;
  late TextEditingController nameCon;
  late TextEditingController amountCon;
  late TextEditingController unitCon;
  bool editMode = false;

  @override
  void initState() {
    index = widget.index;
    listModel = widget.listModel;
    name = widget.name;
    amount = widget.amount;
    unit = widget.unit;
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
              ? IntrinsicWidth(
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
                  IntrinsicWidth(
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
              ? IntrinsicWidth(
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
            editMode
                ? IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      listModel.updateItem(
                          name,
                          index,
                          GroceryListItemModel(
                              name: nameCon.text,
                              amount: double.parse(amountCon.text),
                              unit: unitCon.text));
                      setState(() {
                        editMode = false;
                      });
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
                  ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                print(index);
                listModel.removeItem(index, listModel.items[index]);
              },
              splashRadius: 15,
            )
          ]))
        ],
      ),
    ));
  }
}
