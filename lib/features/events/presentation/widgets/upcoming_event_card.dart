import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';

class UpcomingEventCard extends StatefulWidget {
  const UpcomingEventCard({
    super.key,
    required this.event,
    required this.profile,
    required this.onFavTap,
  });

  final EventModel event;
  final ProfileModel? profile;
  final Function(String eventId) onFavTap;

  @override
  State<UpcomingEventCard> createState() => _UpcomingEventCardState();
}

class _UpcomingEventCardState extends State<UpcomingEventCard> {
  String daysUntilEvent(DateTime eventDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final event = DateTime(eventDate.year, eventDate.month, eventDate.day);
    final diff = event.difference(today).inDays;
    return '$diff';
  }

  bool isEventFavorited() {
    final profile = widget.profile;
    return profile?.favoriteEvents.any((e) => e == widget.event.id) ?? false;
  }

  @override
  void didUpdateWidget(UpcomingEventCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _isFavorited = isEventFavorited();
    }
  }

  @override
  void initState() {
    super.initState();
    _isFavorited = isEventFavorited();
  }

  Future<void> _toggleFavorite() async {
    widget.onFavTap(widget.event.id);
    setState(() => _isFavorited = !_isFavorited);

    final messenger = ScaffoldMessenger.of(context);
    messenger
        .removeCurrentSnackBar(); // corta o anterior na hora, sem esperar a fila

    messenger.showSnackBar(
      SnackBar(
        content: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.4),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                ),
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: Row(
            key: ValueKey(
              _isFavorited,
            ), // força o AnimatedSwitcher a animar na troca
            children: [
              Icon(
                _isFavorited ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                _isFavorited ? 'Evento favoritado!' : 'Removido dos favoritos',
              ),
            ],
          ),
        ),
        backgroundColor: Color(int.parse(widget.event.color)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
        duration: const Duration(
          milliseconds: 1400,
        ), // mais curto, responde mais rápido a cliques seguidos
        animation: CurvedAnimation(
          parent: const AlwaysStoppedAnimation(1),
          curve: Curves.easeInCirc,
        ),
      ),
    );
  }

  bool _isFavorited = false;
  @override
  Widget build(BuildContext context) {
    final hour = DateFormat('HH:mm').format(widget.event.date.toLocal());
    bool isFav = isEventFavorited();
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: InkWell(
        onTap: () => context.push('/events/${widget.event.id}'),
        borderRadius: BorderRadius.circular(20),
        child: Card(
          shadowColor: Theme.of(context).colorScheme.onSurface,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // imagem com altura fixa
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                  bottom: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 112,
                      child: Image.network(
                        widget.event.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(color: Colors.black.withOpacity(0.5)),
                    ),
                    Positioned.fill(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(
                                int.parse(widget.event.color),
                              ).withOpacity(0.75),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    spacing: 14,
                                    children: [
                                      Container(
                                        width: 77,
                                        height: 77,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 9,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.30),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              daysUntilEvent(
                                                widget.event.date.toLocal(),
                                              ),
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.surface,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'dias',
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.surface,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 2,
                                          children: [
                                            Text(
                                              widget.event.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            Row(
                                              children: [
                                                Flexible(
                                                  // ✅
                                                  child: Text(
                                                    widget.event.location,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  ' • ',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                Text(
                                                  hour,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.30),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface
                                                      .withOpacity(0.3),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                widget.event.category,
                                                style: TextStyle(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.surface,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: _toggleFavorite,
                                  icon: Icon(
                                    _isFavorited
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _isFavorited
                                        ? Color(int.parse(widget.event.color))
                                        : Colors.white,
                                    size: 20,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.black.withOpacity(
                                      0.3,
                                    ),
                                    minimumSize: const Size(32, 32),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
