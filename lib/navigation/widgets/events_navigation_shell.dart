import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';
import 'package:vynce_frontend/features/events/data/services/profile_service.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/category_badges.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/search_event.dart';

class EventsNavigationShell extends StatefulWidget {
  const EventsNavigationShell({super.key, required this.child});
  final Widget child;

  @override
  State<EventsNavigationShell> createState() => _EventsNavigationShellState();
}

class _EventsNavigationShellState extends State<EventsNavigationShell> {
  ProfileService _profileService = getIt<ProfileService>();
  ProfileModel? profile;
  @override
  initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final result = await _profileService.getProfile('1');
    setState(() {
      profile = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(212),
        child: SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.inversePrimary,
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1A1A1A),
                            ),
                            children: [
                              TextSpan(text: 'Boa noite, '),
                              TextSpan(
                                text: profile?.name ?? 'Ana',
                                style: TextStyle(color: Color(0xFFD4537E)),
                              ),
                              TextSpan(text: ' 👋'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Você tem ${profile?.pendingMatches ?? 3} matches!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        getCircularAvatar(),

                        // badge de notificação
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SearchEvent(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: CategoryBadges(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: widget.child,
    );
  }

  Widget getCircularAvatar() {
    if (profile?.avatarUrl == null) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFF7F77DD),
        child: Text(
          profile?.name?.substring(0, 2) ?? '',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(profile!.avatarUrl),
      );
    }
  }
}
