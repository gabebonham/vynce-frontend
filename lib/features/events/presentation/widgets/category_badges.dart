import 'package:flutter/material.dart';

class CategoryBadges extends StatefulWidget {
  const CategoryBadges({super.key, required this.categories, required this.onTap});

  final List<String> categories;
  final Function(String) onTap;

  @override
  State<CategoryBadges> createState() => _CategoryBadgesState();
}

class _CategoryBadgesState extends State<CategoryBadges> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.categories.map((cat) {
        return GestureDetector(
          onTap: () => widget.onTap(cat),
          child: Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              cat,
              style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
            ),
          ),
        );
      }).toList(),
    );
  }
}