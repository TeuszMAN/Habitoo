import 'package:flutter/material.dart';

import 'package:habitoo/views/pages/graph_screen.dart';

import 'package:habitoo/views/pages/home_screen.dart';

import 'package:habitoo/views/pages/profile_screen.dart';

import 'package:habitoo/views/pages/questions_screen.dart';
import 'package:habitoo/data/notifiers.dart';
import 'package:habitoo/views/widget/navbar_widget.dart';

List<Widget> pages = [
  GraphScreen(),
  QuestionsScreen(),
  HomeScreen(),
  ProfileScreen(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),

      bottomNavigationBar: NavBarWidget(),
    );
  }
}
