import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/models/event_model.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/avatar_stack.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class EventCard extends StatefulWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.profile,
    required this.onFavTap,
  });
  final Function onFavTap;
  final EventModel event;
  final ProfileModel? profile;

  @override
  State<EventCard> createState() => _EventCardState(event);
}

class _EventCardState extends State<EventCard> {
  bool _isFavorited = false;
  final EventModel event;
  _EventCardState(this.event);
  bool isEventFavorited() {
    final profile = widget.profile;
    return profile?.favoriteEvents.any((e) => e == widget.event.id) ?? false;
  }

  @override
  void didUpdateWidget(EventCard oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat(
      'dd/MM/yyyy • HH:mm',
    ).format(event.date.toLocal());
    return SizedBox(
      width: 220,
      height: 308,
      child: InkWell(
        onTap: () => context.push('/events/${event.id}'),
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
                      width: 220,
                      height: 300,
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
                              ).withOpacity(0.50),
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
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.30),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    event.category,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 2,
                              children: [
                                Text(
                                  formatted,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  event.title,
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
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        event.location,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.70),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                AvatarStack(
                                  totalCount: event.participantsCount,
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
