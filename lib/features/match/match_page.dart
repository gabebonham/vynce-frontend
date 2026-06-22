import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/models/ongoing_event_model.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/events/data/services/profile_service.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            // header com nome do evento
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const BackButton(),
                  Expanded(
                    child: Text(
                      _event?.title ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 40), // balancear o BackButton
                ],
              ),
            ),

            // deck de cards
            Expanded(
              child: Stack(
                children: _profiles
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final profile = entry.value;
                      final isTop = index == 0;

                      return Positioned.fill(
                        child: Transform.scale(
                          scale: isTop ? 1.0 : 1.0 - (index * 0.03),
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              index * 8.0,
                            ), // deslocamento vertical p/ efeito de pilha
                            child: SwipeCard(
                              profile: profile,
                              onLike: isTop ? _onLike : () {},
                              onDislike: isTop ? _onDislike : () {},
                              event: _event!,
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
