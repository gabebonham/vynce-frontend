class EventFilter {
  late String? category;
  late int minParticipants;
  late double maxDistanceKm;
  late String? dateRange;
  late bool onlyFavorites;

  EventFilter({
    this.category,
    this.minParticipants = 0,
    this.maxDistanceKm = 100,
    this.dateRange,
    this.onlyFavorites = false,
  });

  EventFilter copyWith({
    String? category,
    int? minParticipants,
    double? maxDistanceKm,
    String? dateRange,
    bool? onlyFavorites,
  }) {
    return EventFilter(
      category: category ?? this.category,
      minParticipants: minParticipants ?? this.minParticipants,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      dateRange: dateRange ?? this.dateRange,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
    );
  }
}
