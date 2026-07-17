import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/core/models/event_filter.dart';
import 'package:vynce_frontend/features/events/widgets/filter_dialog.dart';

class SearchEvent extends StatefulWidget {
  const SearchEvent({super.key});

  @override
  State<SearchEvent> createState() => _SearchEventState();
}

class _SearchEventState extends State<SearchEvent> {
  final TextEditingController _controller = TextEditingController();

  EventFilter? currentFilter;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String value) {
    final uri = GoRouterState.of(context).uri;
    final newParams = Map<String, String>.from(uri.queryParameters);
    if (value.isEmpty) {
      newParams.remove('title');
    } else {
      newParams['title'] = value;
    }
    context.go(
      uri
          .replace(path: '/events-filtered', queryParameters: newParams)
          .toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: Colors.black38),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: _onSearchSubmitted,
              decoration: const InputDecoration(
                hintText: 'Buscar eventos...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, size: 18, color: Colors.black38),
            onPressed: () {
              final currentFilter = getFilters(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: EventFilterModal(
                    initialFilter: currentFilter,
                    onApply: (filter) {
                      applyFilters(filter);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  EventFilter getFilters(BuildContext context) {
    final category = GoRouterState.of(context).uri.queryParameters['category'];
    final minParticipants = int.tryParse(
      GoRouterState.of(context).uri.queryParameters['minParticipants'] ?? '0',
    );
    final maxDistanceKm = double.tryParse(
      GoRouterState.of(context).uri.queryParameters['maxDistanceKm'] ?? '100',
    );
    final dateRange = GoRouterState.of(
      context,
    ).uri.queryParameters['dateRange'];
    final onlyFavorites = bool.tryParse(
      GoRouterState.of(context).uri.queryParameters['onlyFavorites'] ?? 'false',
    );
    return EventFilter(
      category: category,
      minParticipants: minParticipants ?? 0,
      maxDistanceKm: maxDistanceKm ?? 100,
      dateRange: dateRange,
      onlyFavorites: onlyFavorites ?? false,
    );
  }

  void applyFilters(EventFilter filter) {
    EventFilter finalFilter = filter;
    if (finalFilter.category == null && currentFilter?.category != null) {
      finalFilter = finalFilter.copyWith(category: currentFilter?.category);
    }

    final existingTitle = GoRouterState.of(
      context,
    ).uri.queryParameters['title'];

    context.push(
      Uri(
        path: '/events-filtered',
        queryParameters: {
          if (finalFilter.category != null) 'category': finalFilter.category!,
          'minParticipants': finalFilter.minParticipants.toString(),
          'maxDistanceKm': finalFilter.maxDistanceKm.toString(),
          if (finalFilter.dateRange != null)
            'dateRange': finalFilter.dateRange!,
          'onlyFavorites': finalFilter.onlyFavorites.toString(),
          if (existingTitle != null && existingTitle.isNotEmpty)
            'title': existingTitle,
        },
      ).toString(),
    );
  }
}
