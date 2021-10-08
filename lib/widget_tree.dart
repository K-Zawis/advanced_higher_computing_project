import 'package:flutter/material.dart';
import 'package:learn_languages/responsive_layout.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: (ResponsiveLayout.isTinyLimit(context) || ResponsiveLayout.isTinyHeightLimit(context)) ? Container() : AppBar(),
        preferredSize: const Size(double.infinity, 100),
      ),
      body: const ResponsiveLayout(
        tiny: Text(
          'tiny',
        ),
        phone: Text(
          'phone',
        ),
        tablet: Text(
          'tablet',
        ),
        largeTablet: Text(
          'large tablet',
        ),
        computer: Text(
          'computer',
        ),
      ),
    );
  }
}
