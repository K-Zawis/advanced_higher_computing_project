import 'package:flutter/material.dart';
import 'package:learn_languages/pages/home_page.dart';
import 'package:learn_languages/pages/home_page_desktop.dart';
import 'package:learn_languages/responsive_layout.dart';
import 'package:learn_languages/widgets/menu_drawer.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(
        elevation: 10.0,
      ),
      /*appBar: PreferredSize(
        child: (ResponsiveLayout.isTinyLimit(context) || ResponsiveLayout.isTinyHeightLimit(context)) ? Container() : AppBar(),
        preferredSize: const Size(double.infinity, 50),
      ),*/
      body: ResponsiveLayout(
        tiny: const Text(
          '',
        ),
        phone: const HomePage(),
        tablet: const HomePage(),
        largeTablet: const HomePage(),
        computer: Row(
          children: const [
            MenuDrawer(
              elevation: 0.0,
            ),
            Expanded(child: DesktopHomePage()),
          ],
        ),
      ),
    );
  }
}
