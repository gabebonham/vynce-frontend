import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 8, bottom:8),
          child: Column(
            spacing: 8,
            children: [
              // Itens do topo
              ListTile(
                splashColor: Color.fromARGB(0, 255, 255, 255),
                hoverColor: Color.fromARGB(0, 255, 255, 255),
                leading: const Icon(Icons.person),
                title: const Text('Perfil'),
                onTap: () {},
              ),
              ListTile(
                splashColor: Color.fromARGB(0, 255, 255, 255),
                hoverColor: Color.fromARGB(0, 255, 255, 255),
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {},
              ),

              // Empurra o logout pro fundo
              const Spacer(),

              // Botão de logout fixo no fundo
              ListTile(
                splashColor: Color.fromARGB(0, 255, 255, 255),
                hoverColor: Color.fromARGB(0, 255, 255, 255),
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Sair', style: TextStyle(color: Colors.red)),
                onTap: () {
                  // lógica de logout
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
