import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/core/models/host_model.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';
import 'package:vynce_frontend/core/services/host_service.dart';
import 'package:vynce_frontend/core/services/profile_service.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/event_card.dart';

class HostProfilePage extends StatefulWidget {
  const HostProfilePage({super.key, required this.id});
  final String id;

  @override
  State<HostProfilePage> createState() => _HostProfilePageState();
}

class _HostProfilePageState extends State<HostProfilePage> {
  final HostService _hostService = getIt<HostService>();
  final ProfileService _profileService = getIt<ProfileService>();
  HostModel? _host;
  ProfileModel? _profile;

  @override
  void initState() {
    super.initState();
    loadProfile();
    loadHost();
  }

  Future<void> loadProfile() async {
    final result = await _profileService.getProfile(widget.id);

    setState(() {
      _profile = result;
    });
  }

  Future<void> loadHost() async {
    final result = await _hostService.getHost(widget.id);

    setState(() {
      _host = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_host == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          spacing: 32,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // cover + header foto
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Image.network(
                    _host!.bannerUrl ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 42,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: _headerImg(),
                  ),
                ),
              ],
            ),

            // conteúdo abaixo da imagem — aqui era o Positioned errado
            _header(),
            _counts(),
            _eventsOwned(),
            SizedBox(height: 46),
          ],
        ),
      ),
    );
  }

  Widget _eventsOwned() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('EVENTOS QUE ORGANIZEI'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 12,
              children: _host!.events
                  .map(
                    (event) => EventCard(
                      event: event,
                      profile: _profile,
                      onFavTap: (String eventId) {},
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _counts() {
    return Column(
      children: [
        Divider(
          thickness: 0.5, // espessura da linha
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        ),
        IntrinsicHeight(
          // <- define altura baseada nos filhos
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      _host!.events.length.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    Text('EVENTOS', style: TextStyle(fontSize: 12)),
                  ],
                ),
                VerticalDivider(
                  width: 32, // espaço horizontal total
                  thickness: 0.5, // espessura da linha
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.3),
                ),
                Column(
                  children: [
                    Text(
                      _host!.followersCount.toString(),

                      style: TextStyle(fontSize: 16),
                    ),
                    Text('SEGUIDORES', style: TextStyle(fontSize: 12)),
                  ],
                ),
                VerticalDivider(
                  width: 32, // espaço horizontal total
                  thickness: 0.5, // espessura da linha
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.3),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [StarRating(initialRating: _host!.rating)],
                ),
              ],
            ),
          ),
        ),

        Divider(
          thickness: 0.5, // espessura da linha
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        ),
      ],
    );
  }

  List<Widget> _getEventCategories() {
    return _host!.events
        .map(
          (event) => Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Color(int.parse(event.color)).withOpacity(0.5),
              ),
              color: Color(int.parse(event.color)).withOpacity(0.2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              child: Text(
                event.category,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 3,
                horizontal: 10,
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _headerImg() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(child: Icon(Icons.arrow_back)),
        GestureDetector(child: Icon(Icons.more_horiz)),
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
      child: Column(
        spacing: 12,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: CircleAvatar(
                  radius: 42,
                  backgroundImage: NetworkImage(_host!.avatarUrl),
                ),
              ),
              Row(
                spacing: 18,
                children: [
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(6),
                        child: Icon(Icons.chat_bubble_outline_outlined),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Seguir",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _host!.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    _host!.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),

              Text(
                _host!.bio ?? "",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Row(spacing: 6, children: _getEventCategories()),
            ],
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatefulWidget {
  const StarRating({
    super.key,
    this.onRatingChanged,
    this.interactable = false,
    this.size = 18,
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
