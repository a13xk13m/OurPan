import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/screens/add_recipe_screen.dart';
import 'package:our_pan/screens/grocery_list_screen.dart';
import 'package:our_pan/widgets/grocery_list_item.dart';

class FAB extends StatelessWidget {
  final GroceryListModel groceryListModel;

  const FAB({required this.groceryListModel});

  bool isNumeric(String s) {
    try {
      num.parse(s);
      return true;
    } on Exception {
      return false;
    }
  }

  // Grocery List Dialog.
  Future<dynamic> createAlertDialog(BuildContext context) {
    //promise to return string
    TextEditingController nameCon = TextEditingController();
    TextEditingController amountCon = TextEditingController();
    // TODO: Convert from text box to dropdown menu.
    TextEditingController unitCon = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: CustomColors.bars,
            title: Text("Add Item to Grocery List"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                decoration: InputDecoration(hintText: 'Item'),
                controller: nameCon,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Amount'),
                keyboardType: TextInputType.number,
                controller: amountCon,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Unit'),
                controller: unitCon,
              ),
            ]),
            actions: [
              MaterialButton(
                elevation: 5.0,
                child: Text("Add Item"),
                onPressed: () {
                  // TODO: Break dialog out into seperate stateful widget
                  // to add validation.
                  groceryListModel.addGroceryItem(GroceryListItemModel(
                      name: nameCon.text,
                      amount: double.parse(amountCon.text),
                      unit: unitCon.text));
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return (SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 2,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 3,
      tooltip: 'Create a recipe',
      children: [
        SpeedDialChild(
          child: const Icon(Icons.fastfood),
          backgroundColor: CustomColors.bars,
          foregroundColor: Colors.white,
          label: 'Create recipe',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRecipeScreen()),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.list),
          backgroundColor: CustomColors.bars,
          foregroundColor: Colors.white,
          label: 'Add Grocery Item',
          onTap: () => createAlertDialog(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.text_snippet),
          backgroundColor: CustomColors.bars,
          foregroundColor: Colors.white,
          label: 'Add Post',
          onTap: () => null,
        ),
      ],
    ));
  }
}
