library my_prj.constants;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_languages/pages/home_page.dart';
import 'package:learn_languages/pages/home_page_desktop.dart';
import 'package:learn_languages/pages/practice_mode_page.dart';
import 'package:learn_languages/providers/language_provider.dart';
import 'package:learn_languages/providers/qualification_provider.dart';
import 'package:learn_languages/providers/topic_provider.dart';

// * colours
Map<int, Color> color =
{
  50:const Color.fromRGBO(255, 255, 255, 0.1),
  100:const Color.fromRGBO(255, 255, 255, 0.2),
  200:const Color.fromRGBO(255, 255, 255, 0.3),
  300:const Color.fromRGBO(255, 255, 255, 0.4),
  400:const Color.fromRGBO(255, 255, 255, 0.5),
  500:const Color.fromRGBO(255, 255, 255, 0.6),
  600:const Color.fromRGBO(255, 255, 255, 0.7),
  700:const Color.fromRGBO(255, 255, 255, 0.8),
  800:const Color.fromRGBO(255, 255, 255, 0.9),
  900:const Color.fromRGBO(255, 255, 255, 1.0),
};

const scaffoldColour = Color(0xFF18191C);
const canvasColour = Color(0xFF1B1C23);
//const primaryColour = 0xFF3B4669;
//
const primaryColour = 0xFF4D5A92;
const textColour = Color(0xFFD6DEDC);
const dropdownFillColour = Color(0xFFD6DEDC);
const iconColour = Color(0xFFD6DEDC);
const hintColour = Color(0xFF494B50);

// * page map
// TODO -- Find out how to deal with desktop version of pages
// a map of ("page name", WidgetBuilder) pairs
final _availablePages = <String, WidgetBuilder>{
  'Home Page' : (_) => const HomePage(),
  'Desktop Home Page' : (_) => const DesktopHomePage(),
  'Practice Mode' : (_) => const PracticeMode(),
};

// * providers
// this is a `StateProvider` so we can change its value
final selectedPageNameProvider = StateProvider.family<String, String>((ref, type) {
  // default value
  if (type == '') {
    return _availablePages.keys.first;
  } else {
    return _availablePages.keys.firstWhere((element) => element == 'Desktop Home Page');
  }
});
void selectPage(BuildContext context, String pageName, type) {
  // only change the state if we have selected a different page
  if (context.read(selectedPageNameProvider(type)).state != pageName) {
    context.read(selectedPageNameProvider(type)).state = pageName;
  }
}
final selectedPageBuilderProvider = Provider.family<WidgetBuilder, String>((ref, type) {
  // watch for state changes inside selectedPageNameProvider
  final selectedPageKey = ref.watch(selectedPageNameProvider(type)).state;
  // return the WidgetBuilder using the key as index
  return _availablePages[selectedPageKey]!;
});
final languageProvider = ChangeNotifierProvider((ref) => Languages());
final qualificationProvider = ChangeNotifierProvider((ref) => Qualifications());
final topicProvider = ChangeNotifierProvider((ref) {
  var lan = ref.watch(languageProvider).getLanguage();
  var level = ref.watch(qualificationProvider).getLevel();
  return Topics(lan, level);
});