import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/home_page.dart';
import 'pages/home_page_desktop.dart';
import 'responsive_layout.dart';
import 'widgets/menu_drawer.dart';
import 'pages/practice_mode_page.dart';

// TODO -- Find out how to deal with desktop version of pages
// a map of ("page name", WidgetBuilder) pairs
final _availablePages = <String, WidgetBuilder>{
  'Home Page' : (_) => const HomePage(),
  'Practice Mode' : (_) => const PracticeMode(),
};
final _availableDesktopPages = <String, WidgetBuilder>{
  'Home Page' : (_) => const DesktopHomePage(),
  'Practice Mode' : (_) => const PracticeMode(),
};

// this is a `StateProvider` so we can change its value
final selectedPageNameProvider = StateProvider<String>((ref) {
  // default value
    return _availablePages.keys.first;
});
final selectedDesktopPageNameProvider = StateProvider((ref){
  return _availableDesktopPages.keys.first;
});
void selectPage(BuildContext context, String pageName) {
  // only change the state if we have selected a different page
  if (context.read(selectedPageNameProvider).state != pageName) {
    context.read(selectedPageNameProvider).state = pageName;
  }
  if (context.read(selectedDesktopPageNameProvider).state != pageName) {
    context.read(selectedDesktopPageNameProvider).state = pageName;
  }
}
final selectedPageBuilderProvider = Provider<WidgetBuilder>((ref) {
  // watch for state changes inside selectedPageNameProvider
  final selectedPageKey = ref.watch(selectedPageNameProvider).state;
  // return the WidgetBuilder using the key as index
  return _availablePages[selectedPageKey]!;
});
final selectedDesktopPageBuilderProvider = Provider<WidgetBuilder>((ref) {
  // watch for state changes inside selectedPageNameProvider
  final selectedPageKey = ref.watch(selectedDesktopPageNameProvider).state;
  // return the WidgetBuilder using the key as index
  return _availableDesktopPages[selectedPageKey]!;
});

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final selectedPageBuilder = watch(selectedPageBuilderProvider);
      final selectedDesktopPageBuilder = watch(selectedDesktopPageBuilderProvider);
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
