import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/widgets/category_item_widget.dart';
import 'package:shopping_list/widgets/new_item.dart';

class ShoppingListWidget extends StatefulWidget {
  const ShoppingListWidget({super.key});

  @override
  State<ShoppingListWidget> createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {
  
  void _addItem() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const NewItem()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addItem)],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          return CategoryItem(item: groceryItems[index]);
        },
      ),
    );
  }
}
