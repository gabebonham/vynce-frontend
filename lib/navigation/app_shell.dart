import 'package:flutter/material.dart';
import 'package:vynce_frontend/features/events/presentation/pages/events_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  final pages = [
    const EventsPage(),
    const Center(child: Text('Busca')),
    const Center(child: Text('Perfil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          hoverColor: Colors.transparent,
        ),

        child: BottomNavigationBar(
          currentIndex: currentIndex,

          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.celebration),
              label: 'Eventos',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Match',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}