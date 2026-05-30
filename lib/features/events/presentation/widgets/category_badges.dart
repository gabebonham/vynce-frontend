import 'package:flutter/material.dart';

class CategoryBadges extends StatefulWidget {
  const CategoryBadges({
    super.key,
    required this.categories,
    required this.onTap,
    required,
  });

  final List<String> categories;
  final Function(String) onTap;
  @override
  State<CategoryBadges> createState() => _CategoryBadgesState();
}

class _CategoryBadgesState extends State<CategoryBadges> {
  String? _selected;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.categories.map((cat) {
          final isActive = _selected == cat;
          return GestureDetector(
            onTap: () => tapCategory(cat),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).colorScheme.primary,width: 1)
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void tapCategory(String cat) {
    setState(() {
      _selected = _selected == cat ? null : cat; // toggle
    });
    widget.onTap(cat);
  }
}
