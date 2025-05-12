import 'package:flutter/material.dart';
import 'package:takyeem/features/dashboard/pages/home_page.dart';
import 'package:takyeem/features/reports/pages/reports_main.dart';
import 'package:takyeem/features/students/pages/add_student.dart';

class FlutterNavBar extends StatefulWidget {
  const FlutterNavBar({super.key});

  @override
  State<FlutterNavBar> createState() => _FlutterNavBarState();
}

class _FlutterNavBarState extends State<FlutterNavBar> {
  List<Widget> pages = [
    AddStudentPage(),
    HomePage(),
    const ReportsMain(),
  ];

  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        indicatorColor: Theme.of(context).colorScheme.surface,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'الطلبة',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.report),
            icon: Icon(Icons.report_outlined),
            label: 'التقارير',
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
