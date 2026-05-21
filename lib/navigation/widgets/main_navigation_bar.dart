import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final Function(int) onTap;

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  @override
  Widget build(BuildContext context) {


    return BottomNavigationBar(
          currentIndex: widget.currentIndex,

          onTap: (index) {
            widget.onTap(index);
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
        );
  }
}