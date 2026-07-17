import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/models/event_filter.dart';

class EventFilterModal extends StatefulWidget {
  final void Function(EventFilter filter) onApply;
  const EventFilterModal({
    super.key,
    required this.onApply,
    required this.initialFilter,
  });
  final EventFilter initialFilter;
  @override
  State<EventFilterModal> createState() => _EventFilterModalState();
}

class _EventFilterModalState extends State<EventFilterModal> {
  static const _dateOptions = [
    ('Hoje', 'hoje'),
    ('Esta semana', 'semana'),
    ('Este mês', 'mes'),
    ('Próximo mês', 'proximo'),
  ];
  late EventFilter _currentFilter;
  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 0, 26, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtrar eventos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                TextButton(
                  onPressed: _clearAll,
                  child: const Text(
                    'Limpar tudo',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // --- Participantes ---
            _sectionLabel('Participantes'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mínimo de participantes',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.65),
                  ),
                ),
                _valueBadge('${_currentFilter.minParticipants}+'),
              ],
            ),
            Slider(
              value: _currentFilter.minParticipants.toDouble(),
              min: 0,
              max: 1000,
              divisions: 20,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (v) => setState(
                () => _currentFilter = _currentFilter.copyWith(
                  minParticipants: v.toInt(),
                ),
              ),
            ),
            _sliderLabels('0', '1000+'),
            _divider(),

            // --- Distância ---
            _sectionLabel('Distância'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Raio máximo',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.65),
                  ),
                ),
                _valueBadge('${_currentFilter.maxDistanceKm.toInt()} km'),
              ],
            ),
            Slider(
              value: _currentFilter.maxDistanceKm,
              min: 1,
              max: 100,
              divisions: 99,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (v) => setState(
                () =>
                    _currentFilter = _currentFilter.copyWith(maxDistanceKm: v),
              ),
            ),
            _sliderLabels('1 km', '100 km'),
            _divider(),

            // --- Data ---
            _sectionLabel('Data'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _dateOptions.map((opt) {
                final selected = _currentFilter.dateRange == opt.$2;
                return ChoiceChip(
                  label: Text(opt.$1),
                  selected: selected,
                  onSelected: (_) => setState(
                    () => _currentFilter = _currentFilter.copyWith(
                      dateRange: selected ? null : opt.$2,
                    ),
                  ),
                  selectedColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.05),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  backgroundColor: Colors.white,
                );
              }).toList(),
            ),
            _divider(),

            // --- Favoritos ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apenas favoritos',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      'Exibir somente eventos salvos',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _currentFilter.onlyFavorites,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (v) => setState(
                    () => _currentFilter = _currentFilter.copyWith(
                      onlyFavorites: v,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_currentFilter);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Aplicar filtros',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearAll() => setState(() {
    _currentFilter = EventFilter(
      category: _currentFilter.category,
      minParticipants: 0,
      maxDistanceKm: 100,
      onlyFavorites: false,
    );
  });

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
        letterSpacing: 0.8,
      ),
    ),
  );

  Widget _valueBadge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0xFFFBEAF0),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF993556),
      ),
    ),
  );

  Widget _sliderLabels(String min, String max) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(min, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(max, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    ),
  );

  Widget _divider() => const Divider(height: 40, thickness: 0.5);
}
