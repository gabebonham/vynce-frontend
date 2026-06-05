import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/services/categories_service.dart';

class CategoryBadges extends StatefulWidget {
  const CategoryBadges({super.key, required});

  @override
  State<CategoryBadges> createState() => _CategoryBadgesState();
}

class _CategoryBadgesState extends State<CategoryBadges> {
  String? _selected;
  List<String> categories = [];
  final CategoriesService _categoriesService = getIt<CategoriesService>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCategories();
    });
  }

  Future<void> loadCategories() async {
    final result = await _categoriesService.getCategories();

    setState(() {
      categories = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
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
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
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
      _selected = cat; // sem toggle, seleciona direto
    });

    context
        .push(
          Uri(
            path: '/events-filtered',
            queryParameters: {'category': cat},
          ).toString(),
        )
        .then((_) {
          // quando voltar da página, limpa a seleção
          setState(() {
            _selected = null;
          });
        });
  }
}
