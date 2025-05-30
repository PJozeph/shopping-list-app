import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/categories.dart';

import 'package:http/http.dart' as http;
import 'package:shopping_list/models/category_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var _enteredName = '';
    var _selectedCategory = categories[Categories.dairy];
    var _selectedQuantity;
    var _isSending = false;

    void _saveForm() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isSending = true;
        });

        final url = Uri.https(
          'abcshopping-list-app-37c8d-default-rtdb.europe-west1.firebasedatabase.app',
          'shopping-list.json',
        );

        final addResponse = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            'name': _enteredName,
            'quantity': _selectedQuantity,
            'category': _selectedCategory?.name,
          }),
        );

        final newItem = GroceryItem(
          id: json.decode(addResponse.body)['name'],
          name: _enteredName,
          quantity: _selectedQuantity,
          category: _selectedCategory!,
        );
        Navigator.of(context).pop(newItem);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value ?? '';
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a quantity';
                        }
                        final quantity = int.tryParse(value);
                        if (quantity == null || quantity <= 0) {
                          return 'Please enter a valid quantity';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _selectedQuantity = int.tryParse(value ?? '1');
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items:
                          categories.entries
                              .map(
                                (entry) => DropdownMenuItem(
                                  value: entry.value,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        color: entry.value.color,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(entry.value.name),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {},
                      onSaved: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _isSending
                            ? null
                            : () {
                              _formKey.currentState?.reset();
                            },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveForm,
                    child:
                        _isSending
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
