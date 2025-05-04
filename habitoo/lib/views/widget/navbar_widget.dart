import 'package:flutter/material.dart';
import 'package:habitoo/data/notifiers.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.data_thresholding),
              label: 'Grafico',
            ),
            NavigationDestination(
              icon: Icon(Icons.edit_document),
              label: 'Questionario',
            ),
            NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
          ],
          onDestinationSelected: (int value) {
            selectedPageNotifier.value = value;
          },
          selectedIndex: selectedPage,
        );
      },
    );
  }
}
