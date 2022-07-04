import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:learn_languages/pages/home_page.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vrouter/vrouter.dart';

import '/extensions/string_extensions.dart';
import '/pages/forgot_password_page.dart';
import 'pages/auth_page.dart';
import 'pages/welcome_page.dart';

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
          titleSpacing: 0,
        ),
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      mode: VRouterMode.history,
      initialUrl: '/',
      routes: [
        VWidget(
          path: '/',
          widget: Title(
            color: Colors.black,
            title: 'Welcome page',
            child: const WelcomePage(),
          ),
        ),
        VPopHandler(
          onSystemPop: (vRedirector) async {
            // DO check if going back is possible
            if (vRedirector.historyCanBack()) {
              vRedirector.historyBack();
            }
          },
          onPop: (vRedirector) async {
            // DO check if going back is possible
            if (vRedirector.historyCanBack()) {
              vRedirector.historyBack();
            }
          },
          stackedRoutes: [
            VWidget.builder(
              path: '/auth/:state',
              name: 'auth',
              builder: (context, params) => Title(
                color: Colors.black,
                title: (params.pathParameters['state'] ?? 'register').toCapitalized(),
                child: LogInPage(state: params.pathParameters['state'] ?? 'register'),
              ),
              aliases: const ['/auth/register', '/auth/login'],
            ),
            VWidget(
              path: '/auth/login/forgot-password',
              widget: Title(
                color: Colors.black,
                title: 'Forgot password',
                child: const ForgotPasswordPage(),
              ),
            ),
            VWidget.builder(
              path: '/home',
              name: 'home',
              builder: (context, state) => Title(
                color: Colors.black,
                title: 'Home page',
                child: HomePage(
                  languageId: state.queryParameters['language']!,
                  levelId: state.queryParameters['level']!,
                ),
              ),
            ),
          ],
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
