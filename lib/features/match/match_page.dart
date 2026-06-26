import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/core/models/event_model.dart';
import 'package:vynce_frontend/core/models/ongoing_event_model.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';
import 'package:vynce_frontend/core/services/event_service.dart';
import 'package:vynce_frontend/core/services/profile_service.dart';
import 'package:vynce_frontend/features/match/widgets/swipe_card.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key, required this.eventId});
  final String eventId;
  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final EventsService _eventsService = getIt<EventsService>();
  final ProfileService _profilesService = getIt<ProfileService>();
  OngoingEventModel? _event;
  List<ProfileModel> _profiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEvent();
  }

  Future<void> loadEvent() async {
    final result = await _eventsService.getOngoingEvent(widget.eventId);

    setState(() {
      _event = result;
      _profiles = result.checkedInParticipants;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_profiles.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Ninguém por aqui ainda.')),
      );
    }
    if (_event == null) {
      return const Scaffold(
        body: Center(child: Text('Evento não encontrado.')),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.onPrimary, // meio
              Theme.of(context).colorScheme.primary.withOpacity(0.4), // bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // header com nome do evento
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48),
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withOpacity(0.1),
                      ),
                      child: BackButton(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _event?.title ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withOpacity(0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 40), // balancear o BackButton
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
                  child: Stack(
                    children: _profiles
                        .asMap()
                        .entries
                        .map((entry) {
                          final index = entry.key;
                          final profile = entry.value;
                          final isTop = index == 0;

                          return Positioned.fill(
                            child: IgnorePointer(
                              ignoring: !isTop,
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: isTop
                                      ? [
                                          Colors.white,
                                          Colors.white,
                                        ] // sem efeito no card da frente
                                      : [
                                          Colors.transparent,
                                          Colors.white.withOpacity(0.3),
                                          Colors.white.withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                  stops: isTop
                                      ? [0.0, 1.0]
                                      : [0.0, 0.25, 0.75, 1.0],
                                ).createShader(bounds),
                                blendMode: BlendMode.dstIn,
                                child: Transform.scale(
                                  scale: isTop ? 1.0 : 0.97,
                                  child: SwipeCard(
                                    profile: profile,
                                    onLike: isTop ? _onLike : () {},
                                    onDislike: isTop ? _onDislike : () {},
                                    event: _event!,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                        .toList()
                        .reversed
                        .toList(), // reversed p/ o index 0 ficar no topo do Stack
                  ),
                ),
              ),

              // botões de ação
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionButton(
                      icon: Icons.close,
                      color: Colors.red,
                      onTap: _onDislike,
                    ),
                    const SizedBox(width: 32),
                    _ActionButton(
                      icon: Icons.favorite,
                      color: Colors.pink,
                      onTap: _onLike,
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

  void _onLike() {
    setState(() => _profiles.removeAt(0));
    // TODO: chamar API de like
  }

  void _onDislike() {
    setState(() => _profiles.removeAt(0));
    // TODO: chamar API de dislike
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }
}
