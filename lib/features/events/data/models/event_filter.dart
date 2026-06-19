class EventFilter {
  final String? category;
  final String? title;
  final int minParticipants;
  final double maxDistanceKm;
  final String? dateRange;
  final bool onlyFavorites;

  const EventFilter({
    this.category,
    this.title,
    this.minParticipants = 0,
    this.maxDistanceKm = 100,
    this.dateRange,
    this.onlyFavorites = false,
  });

  EventFilter copyWith({
    Object? category = _unset,
    Object? title = _unset,
    int? minParticipants,
    double? maxDistanceKm,
    Object? dateRange = _unset,
    bool? onlyFavorites,
  }) {
    return EventFilter(
      category: category == _unset ? this.category : category as String?,
      title: title == _unset ? this.title : title as String?,
      minParticipants: minParticipants ?? this.minParticipants,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      dateRange: dateRange == _unset ? this.dateRange : dateRange as String?,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
    );
  }
}

const _unset = Object();
