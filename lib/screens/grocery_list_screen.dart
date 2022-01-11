import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/utils/grocery_list_item_dao.dart';
import 'package:our_pan/widgets/fab.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:our_pan/widgets/grocery_list_item.dart';

// TODO: Maybe add firebase integration to allow sharing of lists.
class GroceryListModel extends ChangeNotifier {
  late List<GroceryListItemModel> _items = <GroceryListItemModel>[];
  final dao = GroceryListItemDao();

  UnmodifiableListView<GroceryListItemModel> get items =>
      UnmodifiableListView(_items);

  int get length => _items.length;

  void addGroceryItem(GroceryListItemModel i) {
    dao.addItem(i);
    _items.add(i);
    notifyListeners();
  }

  void removeItem(int i, GroceryListItemModel item) {
    dao.removeItem(item);
    _items.removeAt(i);
    notifyListeners();
  }

  void setList(List<GroceryListItemModel> l) {
    _items = l;
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }

  // Takes the index of the item and the item to push to database and updates
  // both values.
  void updateItem(String name, int index, GroceryListItemModel item) {
    dao.updateItem(item, name);
    _items[index] = item;
    notifyListeners();
  }

  // Initializes to the data in firebase.
  void init() async {
    _items = await dao.getItems();
    notifyListeners();
  }
}

class GroceryListScreen extends StatefulWidget {
  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();

  GroceryListModel list;
  GroceryListScreen({required GroceryListModel this.list});
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<GroceryListItemModel> items = <GroceryListItemModel>[];
  var menuItems = <String>['Clear List'];

  // Updates the items when a listener event is fired.
  void listenItems() {
    setState(() {
      items = widget.list.items;
    });
  }

  // Adds a listener to listen to changes in GroceryListModel when on grocery
  // list page and also updates the list items on navigation.
  @override
  void initState() {
    super.initState();
    widget.list.addListener(listenItems);
    setState(() {
      items = widget.list.items;
    });
    widget.list.init();
  }

  @override
  void dispose() {
    widget.list.removeListener(listenItems);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return menuItems.map((String choice) {
                return PopupMenuItem<String>(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            },
            onSelected: (item) async {
              switch (item) {
                case 'Clear List':
                  widget.list.removeAll();
                  break;
              }
            },
          )
        ],
        title: Text('Grocery List'),
      ),
      backgroundColor: CustomColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: items.length == 0
              ? Center(
                  child: Text(
                    'Add an item to your list using the "+" button.',
                    style: TextStyle(
                      color: CustomColors.darkText,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: items.length,
                            // TODO: Create more informational cards with size,
                            // notes, etc.
                            itemBuilder: (BuildContext context, int index) {
                              return GroceryListItem(
                                  key: ObjectKey(items[index]),
                                  index: index,
                                  listModel: widget.list,
                                  name: items[index].name,
                                  amount: items[index].amount,
                                  unit: items[index].unit);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                          ))
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
