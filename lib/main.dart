import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../constants.dart';
import '../widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userStateProvider);
    return MaterialApp(
      title: 'Learn Languages',
      theme: ThemeData(
        scaffoldBackgroundColor: scaffoldColour,
        canvasColor: canvasColour,
        hintColor: hintColour,
        textTheme: const TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: textColour,
          displayColor: textColour,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(primaryColour, color),
        ).copyWith(
          secondary: textColour,
        ),
      ),
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Title(color: Colors.black,
    title: ref.watch(titleProvider),
    child: const WidgetTree());
  }
}
