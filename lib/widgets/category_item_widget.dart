import 'package:flutter/material.dart';
import 'package:shopping_list/models/category_item.dart';

class CategoryItem extends StatelessWidget {
  final GroceryItem item;
  const CategoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.rectangle, color: item.category.color),
              const SizedBox(width: 10),
              Text(item.name, style: const TextStyle(fontSize: 20)),
            ],
          ),
          const Spacer(),
          Text('${item.quantity}', style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
