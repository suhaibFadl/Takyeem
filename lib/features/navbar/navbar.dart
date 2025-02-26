import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:takyeem/features/dashboard/pages/test.dart';
import 'package:takyeem/features/reports/pages/reports_main.dart';
import 'package:takyeem/features/students/pages/add_student.dart';
import 'package:takyeem/features/dashboard/pages/home_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );

  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  EdgeInsets padding = const EdgeInsets.all(12);

  int _selectedItemPosition = 1;
  SnakeShape snakeShape = SnakeShape.circle;

  bool showSelectedLabels = false;
  bool showUnselectedLabels = false;

  Color selectedColor = Colors.black;
  Color unselectedColor = Colors.blueGrey;

  Gradient selectedGradient =
      const LinearGradient(colors: [Colors.red, Colors.amber]);
  Gradient unselectedGradient =
      const LinearGradient(colors: [Colors.red, Colors.blueGrey]);

  Color? containerColor;
  List<Color> containerColors = [
    const Color(0xFFFDE1D7),
    const Color(0xFFE4EDF5),
    const Color(0xFFE7EEED),
    const Color(0xFFF4E4CE),
  ];

  List<Widget> pages = [
    AddStudentPage(),
    HomePage(),
    const ReportsMain(),
  ];

  @override
  Widget build(BuildContext context) {
    // FlutterNativeSplash.remove();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        // resizeToAvoidBottomInset: true,
        // extendBody: true,
        // appBar: AppBar(
        //   centerTitle: false,
        //   // leading: IconButton(
        //   //     icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   //     onPressed: () {}),
        //   // title: const Text('Go back', style: TextStyle(color: Colors.black)),
        //   elevation: 0,
        //   // backgroundColor: Colors.transparent,
        //   // systemOverlayStyle: SystemUiOverlayStyle.dark,
        // ),
        body: pages[_selectedItemPosition],
        bottomNavigationBar: SnakeNavigationBar.color(
          padding:
              const EdgeInsets.only(top: 0, bottom: 5, left: 10, right: 10),
          height: 50,
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.circle,
          shape: bottomBarShape,
          // padding: padding,

          ///configuration for SnakeNavigationBar.color

          backgroundColor: Theme.of(context).colorScheme.primary,
          snakeViewColor: Colors.transparent,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.surface,

          ///configuration for SnakeNavigationBar.gradient
          // snakeViewGradient: selectedGradient,
          // selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
          // unselectedItemGradient: unselectedGradient,

          showUnselectedLabels: showUnselectedLabels,
          showSelectedLabels: showSelectedLabels,

          currentIndex: _selectedItemPosition,
          onTap: (index) => setState(() => _selectedItemPosition = index),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'add student'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.table_rows_rounded), label: 'reports'),
            // BottomNavigationBarItem(icon: Icon(Icons.tab), label: 'reports'),

            // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.podcasts), label: 'microphone'),
            // BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search')
          ],
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
        ),
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _selectedItemPosition = page;
    });
    // switch (page) {
    //   case 0:
    //     setState(() {
    //       snakeBarStyle = SnakeBarBehaviour.floating;
    //       snakeShape = SnakeShape.circle;
    //       padding = const EdgeInsets.all(12);
    //       bottomBarShape =
    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
    //       showSelectedLabels = false;
    //       showUnselectedLabels = false;
    //     });
    //     break;
    //   case 1:
    //     setState(() {
    //       snakeBarStyle = SnakeBarBehaviour.pinned;
    //       snakeShape = SnakeShape.circle;
    //       padding = EdgeInsets.zero;
    //       bottomBarShape = RoundedRectangleBorder(borderRadius: _borderRadius);
    //       showSelectedLabels = false;
    //       showUnselectedLabels = false;
    //     });
    //     break;

    //   case 2:
    //     setState(() {
    //       snakeBarStyle = SnakeBarBehaviour.pinned;
    //       snakeShape = SnakeShape.rectangle;
    //       padding = EdgeInsets.zero;
    //       bottomBarShape = BeveledRectangleBorder(borderRadius: _borderRadius);
    //       showSelectedLabels = true;
    //       showUnselectedLabels = true;
    //     });
    //     break;
    //   case 3:
    //     setState(() {
    //       snakeBarStyle = SnakeBarBehaviour.pinned;
    //       snakeShape = SnakeShape.indicator;
    //       padding = EdgeInsets.zero;
    //       bottomBarShape = null;
    //       showSelectedLabels = false;
    //       showUnselectedLabels = false;
    //     });
    // break;
  }
}

class PagerPageWidget extends StatelessWidget {
  final String? text;
  final String? description;
  final Image? image;
  final TextStyle titleStyle =
      const TextStyle(fontSize: 40, fontFamily: 'SourceSerifPro');
  final TextStyle subtitleStyle = const TextStyle(
    fontSize: 20,
    fontFamily: 'Ubuntu',
    fontWeight: FontWeight.w200,
  );

  const PagerPageWidget({
    Key? key,
    this.text,
    this.description,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: OrientationBuilder(builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _portraitWidget()
              : _horizontalWidget(context);
        }),
      ),
    );
  }

  Widget _portraitWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(text!, style: titleStyle),
            const SizedBox(height: 16),
            Text(description!, style: subtitleStyle),
          ],
        ),
        image!
      ],
    );
  }

  Widget _horizontalWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(text!, style: titleStyle),
              Text(description!, style: subtitleStyle),
            ],
          ),
        ),
        Expanded(child: image!)
      ],
    );
  }
}
