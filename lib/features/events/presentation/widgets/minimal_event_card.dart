import 'package:flutter/material.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';

class MinimalEventCard extends StatefulWidget {
  const MinimalEventCard({
    super.key,
    required this.event,
    required this.profile,
    required this.onFavTap,
  });
  final EventModel event;
  final ProfileModel? profile;
  final Function(String) onFavTap;

  @override
  State<MinimalEventCard> createState() => _MinimalEventCardState();
}

class _MinimalEventCardState extends State<MinimalEventCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: InkWell(
        onTap: () => context.push('/events/${widget.event.id}'),
        borderRadius: BorderRadius.circular(20),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Color(int.parse(widget.event.color)),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      width: 2,
                      color: Color(int.parse(widget.event.color)),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // 20 - border width (2)
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        widget.event.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CardDescription(
                    isEventFavorited: isEventFavorited(),
                    event: widget.event,
                    onFavTap: widget.onFavTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isEventFavorited() {
    final profile = widget.profile;
    return profile?.favoriteEvents.any((e) => e == widget.event.id) ?? false;
  }
}

class CardDescription extends StatefulWidget {
  const CardDescription({
    super.key,
    required this.isEventFavorited,
    required this.event,
    required this.onFavTap,
  });

  final bool isEventFavorited;
  final EventModel event;
  final Function(String) onFavTap;

  @override
  State<CardDescription> createState() => _CardDescriptionState();
}

class _CardDescriptionState extends State<CardDescription> {
  late bool _isFavorited;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.isEventFavorited;
  }

  @override
  void didUpdateWidget(CardDescription oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEventFavorited != widget.isEventFavorited) {
      _isFavorited = widget.isEventFavorited;
    }
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
    final color = _isFavorited
        ? Color(int.parse(widget.event.color))
        : Colors.grey;

    return Column(
      spacing: 2,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.event.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            GestureDetector(
              onTap: _toggleFavorite,
              child: Icon(
                _isFavorited ? Icons.favorite : Icons.favorite_outline,
                color: color,
                size: 18,
              ),
            ),
          ],
        ),
        Text(
          '${DateFormat('dd/MM').format(widget.event.date)} • ${widget.event.location}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(int.parse(widget.event.color)),
              width: 1,
            ),
          ),
          child: Text(
            widget.event.category,
            style: TextStyle(
              fontSize: 8,
              color: Color(int.parse(widget.event.color)),
            ),
          ),
        ),
        Text(
          '${widget.event.participantsCount} irão',
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
