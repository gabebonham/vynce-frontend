import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavingationBar extends StatefulWidget {
  const MainNavingationBar({super.key, required this.child});
  final Widget child;

  @override
  State<MainNavingationBar> createState() => _MainNavingationBarState();
}

class _MainNavingationBarState extends State<MainNavingationBar> {
  int _currentIndex = 0;

  final _tabs = [
    '/events',
    '/map',
    '/chat',
    '/profile',
  ];

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    context.go(_tabs[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        height: 70,
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.calendar_today_rounded,
              label: 'Eventos',
              active: _currentIndex == 0,
              onTap: () => _onTap(0),
            ),
            _NavItem(
              icon: Icons.location_on_outlined,
              label: 'Mapa',
              active: _currentIndex == 1,
              onTap: () => _onTap(1),
            ),
            const SizedBox(width: 36),
            _NavItem(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Chat',
              active: _currentIndex == 2,
              onTap: () => _onTap(2),
            ),
            _NavItem(
              icon: Icons.person_outline_rounded,
              label: 'Perfil',
              active: _currentIndex == 3,
              onTap: () => _onTap(3),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/match'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.favorite_outline, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? Theme.of(context).colorScheme.primary : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}