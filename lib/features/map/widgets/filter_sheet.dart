import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/models/event_filter.dart';

class FilterSheet extends StatefulWidget {
  final EventFilter initialFilter;
  final Function onApply;

  const FilterSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late EventFilter _filter;

  static const _categories = ['Música', 'Festa', 'Tech', 'Gastronomia'];

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtrar eventos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Categoria',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _categories.map((cat) {
              final selected = _filter.category == cat;
              return FilterChip(
                label: Text(cat),
                selected: selected,
                onSelected: (_) => setState(() {
                  _filter = _filter.copyWith(category: selected ? null : cat);
                }),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text('Distância máxima: ${_filter.maxDistanceKm.round()} km'),
          Slider(
            value: _filter.maxDistanceKm,
            min: 5,
            max: 500,
            divisions: 99,
            onChanged: (v) =>
                setState(() => _filter = _filter.copyWith(maxDistanceKm: v)),
          ),
          Text('Mín. participantes: ${_filter.minParticipants}'),
          Slider(
            value: _filter.minParticipants.toDouble(),
            min: 0,
            max: 1000,
            divisions: 100,
            onChanged: (v) => setState(
              () => _filter = _filter.copyWith(minParticipants: v.round()),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: SwitchListTile(
              title: const Text('Somente favoritos'),
              value: _filter.onlyFavorites,
              onChanged: (v) =>
                  setState(() => _filter = _filter.copyWith(onlyFavorites: v)),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => onApplyFilters(),
              child: const Text('Aplicar filtros'),
            ),
          ),
        ],
      ),
    );
  }

  void onApplyFilters() {
    widget.onApply(_filter);
    Navigator.pop(context, _filter);
  }
}
