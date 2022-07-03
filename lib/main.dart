import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:learn_languages/pages/login_page.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrouter/vrouter.dart';

import '../constants.dart';

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
    // ref.watch(userStateProvider);
    return VRouter(
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
        background: Container(
          color: const Color.fromARGB(255, 34, 34, 34),
        ),
      ),
      title: 'Learn Languages',
      theme: ThemeData.dark().copyWith(
        primaryColorDark: Colors.amber,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.amber,
          secondary: Colors.amberAccent,
        ),
        appBarTheme: AppBarTheme(
          color: ThemeData.dark().scaffoldBackgroundColor,
          titleSpacing: 32,
        ),
        inputDecorationTheme:
            const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      mode: VRouterMode.history,
      initialUrl: '/',
      routes: [
        VWidget(
          path: '/',
          widget: const MyHomePage(),
        ),
        VWidget.builder(
          path: '/auth/:state',
          name: 'auth',
          builder: (context, params) =>
              LogInPage(state: params.pathParameters['state'] ?? 'register'),
          aliases: const ['/auth/register', '/auth/login'],
        ),
        VRouteRedirector(
          redirectTo: '/',
          path: r'*',
        ),
      ],
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
    return Title(
      color: Colors.black,
      title: ref.watch(titleProvider),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Learn Languages'),
              const Spacer(),
              TextButton(
                onPressed: () {
                  context.vRouter
                      .toNamed('auth', pathParameters: {'state': 'register'});
                },
                child: const Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              TextButton(
                onPressed: () async {
                  context.vRouter
                      .toNamed('auth', pathParameters: {'state': 'login'});
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text(
                  'Log in',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Stack(
            children: [
              FittedBox(
                child: Text(
                  'Welcome!',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        'I want to practice...',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: FormBuilder(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: FormBuilderDropdown(
                                name: 'language',
                                items: const [],
                              ),
                            ),
                            const SizedBox(
                              width: 32,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Lets go!',
                                  style: TextStyle(fontSize: 21),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          width: double.maxFinite,
          height: 108,
          color: Theme.of(context).dialogBackgroundColor,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Contact me at zawistowska.kasia@outlook.com',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
                const Divider(
                  indent: 64,
                  endIndent: 64,
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () =>
                          launchUrl(Uri.parse('https://github.com/K-Zawis')),
                      child: const Text(
                        'Github',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () => launchUrl(Uri.parse(
                          'https://www.linkedin.com/in/katarzyna-zawistowska-843302196')),
                      child: const Text(
                        'LinkedIn',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () => launchUrl(Uri.parse(
                          'https://www.buymeacoffee.com/zawistowskQ')),
                      child: const Text(
                        'Buy Me a Coffee',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ); // const WidgetTree());
  }
}
