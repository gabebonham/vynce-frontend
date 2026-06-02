import 'dart:math';

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
              color: Color(int.parse(widget.event.borderColor)),
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
                      color: Color(int.parse(widget.event.borderColor)),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorited ? 'Evento favoritado!' : 'Removido dos favoritos',
        ),
        backgroundColor: Color(int.parse(widget.event.borderColor)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = _isFavorited
        ? Color(int.parse(widget.event.borderColor))
        : Colors.grey;

    return Column(
      spacing: 4,
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
            IconButton(
              icon: Icon(
                _isFavorited ? Icons.favorite : Icons.favorite_outline,
                color: color,
                size: 18,
              ),
              padding: EdgeInsets.zero, // <- remove padding
              constraints: const BoxConstraints(),
              onPressed: _toggleFavorite,
            ),
          ],
        ),
        Text(
          '${DateFormat('dd/MM').format(widget.event.date)} • ${widget.event.location}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(int.parse(widget.event.borderColor)),
              width: 1,
            ),
          ),
          child: Text(
            widget.event.category,
            style: TextStyle(
              fontSize: 10,
              color: Color(int.parse(widget.event.borderColor)),
            ),
          ),
        ),
        Text(
          '${widget.event.participantsCount} participantes',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
