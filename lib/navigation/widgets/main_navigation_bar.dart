import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavingationBar extends StatelessWidget {
  const MainNavingationBar({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // true = volta pra raiz da aba se já estiver nela; false = mantém pilha
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: navigationShell,
      bottomNavigationBar: isKeyboardOpen
          ? null
          : BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              height: 70,
              color: Theme.of(context).colorScheme.tertiary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.calendar_today_rounded,
                    label: 'Eventos',
                    active: navigationShell.currentIndex == 0,
                    onTap: () => _onTap(0),
                  ),
                  _NavItem(
                    icon: Icons.location_on_outlined,
                    label: 'Mapa',
                    active: navigationShell.currentIndex == 1,
                    onTap: () => _onTap(1),
                  ),
                  const SizedBox(width: 36),
                  _NavItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Chat',
                    active: navigationShell.currentIndex == 2,
                    onTap: () => _onTap(2),
                  ),
                  _NavItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Perfil',
                    active: navigationShell.currentIndex == 3,
                    onTap: () => _onTap(3),
                  ),
                ],
              ),
            ),
      floatingActionButton: isKeyboardOpen
          ? null
          : FloatingActionButton(
              onPressed: () => context.push('/match/1'),
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
    final color = active
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary.withOpacity(0.7);

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
