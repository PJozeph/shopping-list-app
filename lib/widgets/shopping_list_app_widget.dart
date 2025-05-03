import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/widgets/category_item_widget.dart';

class ShoppingListAppWidget extends StatefulWidget {
  const ShoppingListAppWidget({super.key});

  @override
  State<ShoppingListAppWidget> createState() => _ShoppingListAppWidgetState();
}

class _ShoppingListAppWidgetState extends State<ShoppingListAppWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add your action here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ...groceryItems.map((item) {
            return CategoryItem(item: item);
          }).toList(),
        ],
      ),
    );
  }
}
