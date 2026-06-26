import 'package:flutter/cupertino.dart';
import 'package:vynce_frontend/core/models/event_model.dart';
import 'package:vynce_frontend/core/models/ongoing_event_model.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';
import 'package:flutter/material.dart';

class SwipeCard extends StatefulWidget {
  final ProfileModel profile;
  final OngoingEventModel event;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const SwipeCard({
    super.key,
    required this.profile,
    required this.event,
    required this.onLike,
    required this.onDislike,
  });
  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _dragOffset = Offset.zero;
  double _rotation = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
      _rotation = _dragOffset.dx / 300;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    const threshold = 100.0;

    if (_dragOffset.dx > threshold) {
      _animateOut(direction: 1);
    } else if (_dragOffset.dx < -threshold) {
      _animateOut(direction: -1);
    } else {
      _snapBack(); // Volta para o centro
    }
  }

  void _animateOut({required int direction}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final target = Offset(direction * screenWidth * 1.5, _dragOffset.dy);

    final animation = Tween<Offset>(
      begin: _dragOffset,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    animation.addListener(() {
      setState(() => _dragOffset = animation.value);
    });

    _controller.forward(from: 0).then((_) {
      if (direction == 1) {
        widget.onLike();
      } else {
        widget.onDislike();
      }
    });
  }

  void _snapBack() {
    final animation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    animation.addListener(() {
      setState(() {
        _dragOffset = animation.value;
        _rotation = _dragOffset.dx / 300;
      });
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: _rotation * 0.1, // 0.1 rad de rotação max
          child: _buildCard(),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Stack(
      children: [
        // 1. ShaderMask envolve APENAS imagem + gradientes + conteúdo de texto
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white,
                Colors.white,
                Colors.transparent,
              ],
              stops: const [0.0, 0.12, 0.85, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: Stack(
            children: [
              // Imagem (UMA vez)
              ClipRRect(
                child: Image.network(
                  widget.profile.avatarUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              // Gradiente topo
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 120,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.onPrimary,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Gradiente bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 300,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Conteúdo (nome, bio, chips) — DENTRO do ShaderMask
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.profile.name}  ${widget.profile.age}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white70,
                      size: 14,
                    ),
                    Text(
                      widget.profile.location,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                _EventTag(event: widget.event.title),
                const SizedBox(height: 8),
                Text(
                  widget.profile.bio ?? "",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Wrap(
                  spacing: 8,
                  children: widget.profile.interests
                      .map((i) => _InterestChip(label: i))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        // 2. Badge e overlay FORA do ShaderMask — não somem
        Positioned(top: 16, right: 16, child: _MatchBadge(percent: 12)),
        _SwipeOverlay(dragOffset: _dragOffset),
      ],
    );
  }
}

class _SwipeOverlay extends StatelessWidget {
  final Offset dragOffset;

  const _SwipeOverlay({required this.dragOffset});

  @override
  Widget build(BuildContext context) {
    final likeOpacity = (dragOffset.dx / 150).clamp(0.0, 1.0);
    final nopeOpacity = (-dragOffset.dx / 150).clamp(0.0, 1.0);

    return Stack(
      children: [
        Positioned(
          top: 40,
          left: 20,
          child: Opacity(
            opacity: likeOpacity,
            child: _OverlayLabel(text: 'LIKE', color: Colors.green),
          ),
        ),
        Positioned(
          top: 40,
          right: 20,
          child: Opacity(
            opacity: nopeOpacity,
            child: _OverlayLabel(text: 'NOPE', color: Colors.red),
          ),
        ),
      ],
    );
  }
}

class _MatchBadge extends StatelessWidget {
  final int percent;
  const _MatchBadge({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.pinkAccent.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '⚡ $percent% match',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _EventTag extends StatelessWidget {
  final String event;
  const _EventTag({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today, color: Colors.white70, size: 12),
          const SizedBox(width: 4),
          Text(
            event,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String label;
  const _InterestChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

class _OverlayLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _OverlayLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
