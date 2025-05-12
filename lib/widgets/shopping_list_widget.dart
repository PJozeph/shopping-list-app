import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category_item.dart';
import 'package:shopping_list/widgets/category_item_widget.dart';
import 'package:shopping_list/widgets/new_item.dart';

import 'package:http/http.dart' as http;

class ShoppingListWidget extends StatefulWidget {
  const ShoppingListWidget({super.key});

  @override
  State<ShoppingListWidget> createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  var _error = null;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      'abcshopping-list-app-37c8d-default-rtdb.europe-west1.firebasedatabase.app',
      'shopping-list.json',
    );
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'An error occurred';
        _isLoading = false;
      });
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> _loadedItems = [];
    for (var item in listData.entries) {
      final category =
          categories.entries
              .firstWhere((cat) => cat.value.name == item.value['category'])
              .value;
      _loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems = _loadedItems;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const NewItem()));
    _loadItems();
    if (newItem != null) {
      setState(() {
        _groceryItems.add(newItem as GroceryItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'No items added yet!',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          return CategoryItem(item: _groceryItems[index]);
        },
      );

      if (_error) {
        content = Center(
          child: Text(
            _error,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Listttt'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addItem)],
      ),
      body: content,
    );
  }
}
