import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/models/host_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:intl/intl.dart';
import 'package:vynce_frontend/features/events/data/services/host_service.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.id});
  final String id;
  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final EventsService _eventsService = getIt<EventsService>();
  final HostService _hostService = getIt<HostService>();
  EventModel? event;
  HostModel? profile;
  bool isFavorited = false;
  bool _willGo = false;
  bool _loadingWillGo = false;
  @override
  void initState() {
    super.initState();
    loadEvent();
    loadProfile();
    isFavorited = isEventFavorited();
    _checkWillGo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadEvent() async {
    final result = await _eventsService.getEvent(widget.id);

    setState(() {
      event = result;
      isFavorited = isEventFavorited();
    });
  }

  Future<void> loadProfile() async {
    final result = await _hostService.getHost(widget.id);

    setState(() {
      profile = result;
    });
  }

  bool isEventFavorited() {
    return profile?.favoriteEvents.any((e) => e == event!.id) ?? false;
  }

  Future<void> onFavTap() async {
    await _eventsService.favoriteEvent(widget.id);
    setState(() => isFavorited = !isFavorited);
  }

  @override
  Widget build(BuildContext context) {
    final date = event?.date.toLocal();
    final formatted = date != null
        ? DateFormat('dd/MM/yyyy • HH:mm').format(date)
        : '';
    if (event == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 86),
          child: Column(
            children: [
              ClipRRect(
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 320,
                      child: Image.network(
                        'https://picsum.photos/300',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(12, 32, 12, 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(
                                int.parse(event?.color ?? '0xFF000000'),
                              ).withOpacity(0.4),
                              Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: _header(formatted),
                      ),
                    ),
                  ],
                ),
              ),
              _body(),
              _host(),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 22,
                  vertical: 4,
                ),
                child: _locationCard(),
              ),
              _remainingDetails(),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(22, 0, 22, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: _loadingWillGo
                      ? Center(child: CircularProgressIndicator())
                      : _goButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkWillGo() {
    if (profile?.events == null || profile!.events.isEmpty) {
      setState(() {
        _willGo = false;
      });
      return;
    }
    setState(() {
      _willGo = profile!.events.any((e) => e.id == event!.id);
    });
    return;
  }

  Future<void> _schedule() async {
    setState(() => _loadingWillGo = true);
    final success = await _eventsService.schedule(profile!.id);

    setState(() {
      _willGo = success;
      _loadingWillGo = false;
    });
  }

  Future<void> _unschedule() async {
    setState(() => _loadingWillGo = true);
    final success = await _eventsService.unschedule(profile!.id);

    setState(() {
      _willGo = success;
      _loadingWillGo = false;
    });
  }

  Widget _goButton() {
    return _willGo
        ? TextButton.icon(
            onPressed: _unschedule,
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              alignment: Alignment.center,
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                Text(
                  'Desistir da vaga',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Icon(
                  Icons.close,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          )
        : TextButton.icon(
            onPressed: _schedule,
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              alignment: Alignment.center,
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                Text(
                  'Garantir Vaga',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ],
            ),
          );
  }

  Widget _header(String formatted) {
    bool isClose = DateTime.now().isAfter(event!.date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Colors.black.withOpacity(0.3),
            ),
            shape: WidgetStateProperty.all(CircleBorder()),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(event?.color ?? '0xFF000000')),

                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          vertical: 3,
                          horizontal: 10,
                        ),
                        child: Text(
                          event?.category ?? '',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.surface.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    isClose
                        ? Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: Text(
                                'QUASE CHEGANDO A HORA',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Text(
                      event?.title ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => onFavTap(),
                icon: Icon(
                  isFavorited ? Icons.favorite_outline : Icons.favorite,
                  color: Color(
                    int.parse(event?.color ?? '0xFF000000'),
                  ).withOpacity(0.7),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Colors.black.withOpacity(0.4),
                  ),
                  shape: WidgetStateProperty.all(CircleBorder()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _body() {
    if (event == null) return Placeholder();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_locationAndData(), _about()],
    );
  }

  Widget _locationAndData() {
    if (event == null) return Placeholder();

    final color = Color(int.parse(event?.color ?? '0xFF000000'));

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 16, color: color),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Data',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            getFullDate(),
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: color),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Local',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            event?.fullLocation ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.75),
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getFullDate() {
    if (event == null) return '';
    final date = event!.date.toLocal();

    const days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    const months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Maio',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];

    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    final start = DateFormat('h:mm a').format(date); // sem locale

    final offset = date.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final tz = 'GMT$sign${offset.inHours.abs()}';

    return '$dayName, $monthName ${date.day}, ${date.year} $start ($tz)';
  }

  Widget _about() {
    if (event == null) return Placeholder();

    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sobre esse evento',
            style: TextStyle(
              fontSize: 24,
              color: Color(int.parse(event?.color ?? '0xFF000000')),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event!.description,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _host() {
    if (event == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        final hostId = event!.host!.id;
        if (hostId != null) {
          context.push('/host-profile/$hostId');
        }
      },
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Color(
              int.parse(event?.color ?? '0xFF000000'),
            ).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 42, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                Row(
                  spacing: 14,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(int.parse(event?.color ?? '0xFF000000')),
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(event!.host!.avatarUrl),
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              context.push('/profile/${event!.host!.id}'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Anfitrião',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(width: 16),
                              Text(
                                event!.host!.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                StarRating(initialRating: event!.host!.rating),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _remainingDetails() {
    if (event == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vagas restantes'),
              Text(
                '${event!.maxParticipants - event!.participantsCount} de ${event!.maxParticipants}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Entrada'),
              event!.price == null
                  ? Text(
                      'Gratuita',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Text(
                      event!.price.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationCard() {
    if (event == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 12),
        child: Column(
          spacing: 12,
          children: [
            // ícone centralizado
            Icon(
              Icons.map_outlined,
              color: Theme.of(context).colorScheme.secondary,
              size: 32,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(event!.fullLocation, textAlign: TextAlign.center),
                Text(event!.city, textAlign: TextAlign.center),
              ],
            ),

            // descrição embaixo
            SizedBox(
              height: 40,
              width: 240,
              child: GestureDetector(
                onTap: () {
                  context.go('/map', extra: event!.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.15),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 6,
                    children: [
                      Icon(
                        Icons.directions_outlined,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.8),
                      ),
                      Text(
                        'Abrir no Mapa',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarRating extends StatefulWidget {
  const StarRating({
    super.key,
    this.onRatingChanged,
    this.interactable = false,
    this.size = 22,
    this.color = const Color.fromARGB(255, 255, 153, 0),
    this.initialRating,
  });

  final double? initialRating;
  final bool interactable;
  final void Function(double)? onRatingChanged;
  final double size;
  final Color color;

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double? _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    if (_rating == null) return Text('Sem avaliação ainda.');
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (i) {
        final full = _rating! >= i + 1;
        final half = !full && _rating! >= i + 0.5;

        return GestureDetector(
          onTap: () {
            if (!widget.interactable) return;
            setState(() => _rating = i + 1);
            widget.onRatingChanged?.call(_rating!);
          },
          child: Icon(
            full
                ? Icons.star
                : half
                ? Icons.star_half
                : Icons.star_border,
            size: widget.size,
            color: widget.color,
          ),
        );
      }),
    );
  }
}
