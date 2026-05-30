import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/features/events/presentation/pages/event_page.dart';
import 'package:vynce_frontend/features/events/presentation/pages/events_page.dart';

// O roteador principal do aplicativo
final appRouter = GoRouter(
  initialLocation: '/events',
  routes: [
    // 1. O StatefulShellRoute define o esqueleto (Shell) do app
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Retorna o layout estrutural que envelopa suas páginas
        return Scaffold(
          body: navigationShell, // Exibe a página da aba ativa
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: 'Eventos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },
      // 2. Cada branch representa uma aba independente com seu próprio histórico
      branches: [
        // ABA 1: Eventos (Sua estrutura atual entra aqui)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/events',
              builder: (context, state) => const EventsPage(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return EventPage(id: id);
                  },
                ),
              ],
            ),
          ],
        ),
        // ABA 2: Exemplo de uma nova aba persistente (Perfil)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const Center(child: Text('Página de Perfil')),
            ),
          ],
        ),
      ],
    ),
  ],
);
