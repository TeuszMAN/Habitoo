import 'package:flutter/material.dart';
import 'package:habitoo/data/notifiers.dart';
import 'package:habitoo/views/pages/graphs_page.dart';
import 'package:habitoo/views/pages/home_page.dart';
import 'package:habitoo/views/pages/profile_page.dart';
import 'package:habitoo/views/pages/profile_screen.dart';
import 'package:habitoo/views/pages/questions_page.dart';
import 'package:habitoo/views/widgets/navBar_widget.dart';

List<Widget> pages = [
  GraphsPage(),
  QuestionarioScreen(),
  HomePage(),
  ProfilePage(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(' Welcome to Habitoo'), centerTitle: false),

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
