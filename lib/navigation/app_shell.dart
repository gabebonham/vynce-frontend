import 'package:flutter/material.dart';
import 'package:vynce_frontend/features/events/presentation/pages/events_page.dart';
import 'package:vynce_frontend/navigation/widgets/main_drawer.dart';
import 'package:vynce_frontend/navigation/widgets/main_navigation_bar.dart';

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
      appBar: AppBar(title: const Text('Vynce')),

      drawer: MainDrawer(),

      body: pages[currentIndex],

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(hoverColor: Colors.transparent),

        child: MainNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
