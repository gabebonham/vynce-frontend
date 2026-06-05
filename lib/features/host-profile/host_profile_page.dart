import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/host_model.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';
import 'package:vynce_frontend/features/events/data/services/host_service.dart';
import 'package:vynce_frontend/features/events/data/services/profile_service.dart';

class HostProfilePage extends StatefulWidget {
  const HostProfilePage({super.key, required this.id});
  final String id;

  @override
  State<HostProfilePage> createState() => _HostProfilePageState();
}

class _HostProfilePageState extends State<HostProfilePage> {
  final HostService _hostService = getIt<HostService>();
  HostModel? _host;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final result = await _hostService.getProfile(widget.id);

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
      body: SingleChildScrollView(
        child: Column(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _headerImg(),
                  ),
                ),
              ],
            ),

            // conteúdo abaixo da imagem — aqui era o Positioned errado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: _header(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getEventCategories() {
    return _host!.events
        .map(
          (event) => Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Color(int.parse(event.color)),
              ),
              color: Color(int.parse(event.color)),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(event.category),
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(_host!.avatarUrl),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
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
        Column(
          children: [
            Text(_host!.name),
            Text(_host!.location),
            Text(_host!.bio ?? ""),
            Row(children: _getEventCategories()),
          ],
        ),
      ],
    );
  }
}
