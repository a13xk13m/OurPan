import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:our_pan/widgets/grocery_list_item.dart';
import 'package:our_pan/widgets/ingredients_list.dart';

class GroceryListItemDao {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  late final DatabaseReference ref =
      FirebaseDatabase.instance.ref('users/$uid/list');

  // Add an item to the database.
  void addItem(GroceryListItemModel item) {
    ref.push().set(item.toJson());
  }

  // Remove item from database.
  void removeItem(GroceryListItemModel item) async {
    final response = await ref.once();
    for (var i in response.snapshot.children) {
      Map<dynamic, dynamic> dat = {};
      for (var sub in i.children) {
        dat[sub.key] = sub.value;
      }
      if (item.equals(GroceryListItemModel(
          name: dat['name'], amount: dat['amount'], unit: dat['unit']))) {
        print('removing' + dat.toString());
        i.ref.remove();
      }
    }
  }

  // Updates an item by name.
  void updateItem(GroceryListItemModel item, String name) async {
    final response = await ref.once();
    for (var i in response.snapshot.children) {
      Map<dynamic, dynamic> dat = {};
      for (var sub in i.children) {
        dat[sub.key] = sub.value;
      }
      if (dat['name'] == name) {
        print('updating' + dat.toString());
        i.ref.set(item.toJson());
        break;
      }
    }
  }

  // Get all items.
  Future<List<GroceryListItemModel>> getItems() async {
    final response = await ref.once();
    List<GroceryListItemModel> items = <GroceryListItemModel>[];
    for (var item in response.snapshot.children) {
      Map<dynamic, dynamic> json = {};
      for (var i in item.children) {
        json[i.key] = i.value;
      }
      items.add(GroceryListItemModel.fromJson(json));
    }
    return items;
  }

  // Adds a list of items to a users grocery list.
  // Takes a list of IngredientModels rather than GroceryListItemModels because
  // for some reason I made two representations of the same item.
  Future<void> addMultipleItems(List<IngredientModel> items) async {
    DatabaseReference newLoc = ref.push();
    for (IngredientModel i in items) {
      newLoc.set(i.toJson());
      newLoc = newLoc.push();
    }
  }
}
