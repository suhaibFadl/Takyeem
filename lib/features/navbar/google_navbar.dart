import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:takyeem/features/dashboard/pages/home_page.dart';
import 'package:takyeem/features/reports/pages/reports_main.dart';
import 'package:takyeem/features/students/pages/add_student.dart';

class GoogleNavBar extends StatefulWidget {
  @override
  _GoogleNavBarState createState() => _GoogleNavBarState();
}

class _GoogleNavBarState extends State<GoogleNavBar> {
  int _selectedIndex = 1;
  List<Widget> pages = [
    AddStudentPage(),
    HomePage(),
    const ReportsMain(),
  ];

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'الطلبة',
      style: optionStyle,
    ),
    Text(
      'الرئيسية',
      style: optionStyle,
    ),
    Text(
      'التقارير',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      // appBar: AppBar(
      //   elevation: 20,
      //   title: const Text('GoogleNavBar'),
      // ),
      body: Center(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Theme.of(context).colorScheme.surface,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Theme.of(context).colorScheme.primary,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.person,
                  text: 'الطلبة',
                ),
                GButton(
                  icon: Icons.home,
                  text: 'الرئيسية',
                ),
                GButton(
                  icon: Icons.table_rows_rounded,
                  text: 'التقارير',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
