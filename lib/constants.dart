library my_prj.constants;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// * providers
final languageProvider = ChangeNotifierProvider((ref) => Languages());
final qualificationProvider = ChangeNotifierProvider((ref) => Qualifications());
final topicProvider = ChangeNotifierProvider((ref) {
  var lan = ref.watch(languageProvider).getLanguage();
  var level = ref.watch(qualificationProvider).getLevel();
  return Topics(lan, level);
});