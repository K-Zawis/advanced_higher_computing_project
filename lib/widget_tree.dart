import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants.dart';
import 'responsive_layout.dart';
import 'widgets/menu_drawer.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final selectedPageBuilder = ref.watch(selectedPageBuilderProvider);
      final selectedDesktopPageBuilder = ref.watch(selectedDesktopPageBuilderProvider);
      final selectedMobilePageBuilder = ref.watch (selectedMobilePageBuilderProvider);
      var isLogIn = ref.watch(selectedPageNameProvider.state).state == 'LogIn Page';
      return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: const MenuDrawer(
          elevation: 10.0,
        ),
        body: ResponsiveLayout(
          tiny: const Text(
            '',
          ),
          phone: selectedMobilePageBuilder(context),
          tablet: selectedPageBuilder(context),
          largeTablet: selectedPageBuilder(context),
          computer: Row(
            children: [
              !isLogIn ? const MenuDrawer(
                elevation: 0.0,
              ) : Container(),
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
