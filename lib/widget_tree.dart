import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_languages/constants.dart';
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
    return Consumer(builder: (context, watch, child) {
      final selectedPageBuilder = watch(selectedPageBuilderProvider(''));
      final selectedDesktopPageBuilder = watch(selectedPageBuilderProvider('Comp'));
      return Scaffold(
        drawer: const MenuDrawer(
          elevation: 10.0,
        ),
        body: ResponsiveLayout(
          tiny: const Text(
            '',
          ),
          phone: selectedPageBuilder(context),
          tablet: selectedPageBuilder(context),
          largeTablet: selectedPageBuilder(context),
          computer: Row(
            children: [
              const MenuDrawer(
                elevation: 0.0,
              ),
              Expanded(
                child: selectedDesktopPageBuilder(context),
              ),
            ],
          ),
        ),
      );
    });
  }
}
