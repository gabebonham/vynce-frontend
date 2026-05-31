import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/category_badges.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/events_area.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/search_event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70), // ajusta conforme o conteúdo
        child: SafeArea(
          child: Container(
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Theme.of(context).colorScheme.onSurface,
            //     width: 4,
            //   ),
            // ),
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Linha superior: saudação + avatar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1A1A1A),
                            ),
                            children: [
                              TextSpan(text: 'Boa noite, '),
                              TextSpan(
                                text: 'Ana',
                                style: TextStyle(color: Color(0xFFD4537E)),
                              ),
                              TextSpan(text: ' 👋'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Você tem 3 matches!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFF7F77DD),
                          child: const Text(
                            'AN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // badge de notificação
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD4537E),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SearchEvent(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CategoryBadges(
              categories: [
                'Música',
                'Teatro',
                'Cinema',
                'Esportes',
                'Ciências',
              ],
              onTap: (category) {
                // Handle category tap
              },
            ),
          ),
          Expanded(
            // <-- adiciona isso
            child: Padding(
              padding: EdgeInsetsGeometry.all(12),
              child: EventsArea(),
            ),
          ),
        ],
      ),
    );
  }
}
