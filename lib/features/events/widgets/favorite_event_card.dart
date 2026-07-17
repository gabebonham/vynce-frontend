import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vynce_frontend/core/models/event_model.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';

class FavoriteEventCard extends StatefulWidget {
  const FavoriteEventCard({
    super.key,
    required this.event,
    required this.profile,
    required this.onFavTap,
  });

  final EventModel event;
  final ProfileModel? profile;
  final Function(String eventId) onFavTap;

  @override
  State<FavoriteEventCard> createState() => _FavoriteEventCardState();
}

class _FavoriteEventCardState extends State<FavoriteEventCard> {
  bool _isFavorited = false;
  bool isEventFavorited() {
    final profile = widget.profile;
    return profile?.favoriteEvents.any((e) => e == widget.event.id) ?? false;
  }

  @override
  void didUpdateWidget(FavoriteEventCard oldWidget) {
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
    String locTime = DateFormat(
      'dd MMM • HH:mm',
    ).format(widget.event.date.toLocal());
    return SizedBox(
      width: 220,
      height: 228,
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
                    // 1. imagem
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: Image.network(
                        widget.event.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // 2. overlay escuro geral
                    Positioned.fill(
                      child: Container(color: Colors.black.withOpacity(0.35)),
                    ),

                    // 3. gradiente colorido vindo de baixo
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(
                                int.parse(widget.event.color),
                              ).withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 4. painel de info ancorado no bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 10, 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.event.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                letterSpacing: 0.12,
                                color: Colors.white60,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.event.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  // ✅
                                  child: Text(
                                    widget.event.location,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                                const Text(
                                  ' • ',
                                  style: TextStyle(color: Colors.white54),
                                ),
                                Text(
                                  widget.event.participantsCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white54,
                                  ),
                                ),
                                const Text(
                                  ' irão',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.white.withOpacity(0.15),
                              height: 16,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    locTime,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _toggleFavorite,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    _isFavorited
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 18,
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
