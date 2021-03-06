library my_prj.constants;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_languages/models/langauge_model.dart';
import 'package:learn_languages/models/qualification_model.dart';
import 'package:learn_languages/pages/profile_page_sub_pages/admin_forms/edit_question.dart';
import 'package:learn_languages/pages/profile_page_sub_pages/admin_forms/edit_question_desktop.dart';

import 'models/topic_model.dart';
import 'pages/profile_page_sub_pages/admin_forms/edit_topic.dart';
import 'pages/profile_page_sub_pages/admin_forms/edit_topic_desktop.dart';
import 'pages/profile_page_sub_pages/admin_forms/edit_qualifications.dart';
import 'pages/profile_page_sub_pages/admin_forms/edit_user.dart';
import 'pages/profile_page_sub_pages/admin_forms/edit_user_desktop.dart';
import 'pages/profile_page_sub_pages/data_admin/level_edit_page.dart';
import 'pages/profile_page_sub_pages/data_admin/question_edit_page.dart';
import 'pages/profile_page_sub_pages/data_admin/topic_edit_page.dart';
import 'pages/profile_page_sub_pages/data_admin/language_edit_page.dart';
import 'pages/profile_page_sub_pages/manage_users_page.dart';
import 'pages/profile_page_sub_pages/my_analytics_page.dart';
import 'pages/profile_page_sub_pages/my_questions_page.dart';
import 'pages/practice_mode_page.dart';
import 'pages/assignment_mode_desktop_page.dart';
import 'pages/assignment_mode_page.dart';
import 'pages/profile_page_desktop.dart';
import 'pages/profile_page.dart';
import 'pages/practice_mode_page_desktop.dart';
import 'pages/profile_page_sub_pages/admin_forms/edit_language.dart';
import 'pages/profile_page_sub_pages/admin_forms/edit_language_desktop.dart';
import 'pages/profile_page_sub_pages/admin_forms/edit_qualifications_desktop.dart';

import 'providers/auth_providers/auth_service.dart';
import 'providers/auth_providers/user_state_notifier.dart';
import 'providers/answer_provider.dart';
import 'providers/assesment_provider.dart';
import 'providers/language_provider.dart';
import 'providers/login_provider.dart';
import 'providers/qualification_provider.dart';
import 'providers/question_provider.dart';
import 'providers/topic_provider.dart';
import 'providers/users_provider.dart';

// * colours
Map<int, Color> color = {
  50: const Color.fromRGBO(255, 255, 255, 0.1),
  100: const Color.fromRGBO(255, 255, 255, 0.2),
  200: const Color.fromRGBO(255, 255, 255, 0.3),
  300: const Color.fromRGBO(255, 255, 255, 0.4),
  400: const Color.fromRGBO(255, 255, 255, 0.5),
  500: const Color.fromRGBO(255, 255, 255, 0.6),
  600: const Color.fromRGBO(255, 255, 255, 0.7),
  700: const Color.fromRGBO(255, 255, 255, 0.8),
  800: const Color.fromRGBO(255, 255, 255, 0.9),
  900: const Color.fromRGBO(255, 255, 255, 1.0),
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

// * pages
// a map of ("page name", WidgetBuilder) pairs
final _availablePages = <String, WidgetBuilder>{
  //'Home Page': (_) => const HomePage(),
  'Practice Mode': (_) => const PracticeMode(),
  'Assignment Mode': (_) => const AssignmentMode(),
  //'LogIn Page': (_) => const LogInPage(),
  'Profile Page': (_) => const ProfilePage(),
  'User Page': (_) => const EditUserPage(),
  'Language Page': (_) => const LanguagePage(),
  'Qualification Page': (_) => const QualificationPage(),
  'Topic Page': (_) => const TopicPage(),
  'Question Page': (_) => const QuestionPage(),
};
// TODO -- add mobile version of profile page etc
final _availableMobilePages = <String, WidgetBuilder>{
  //'Home Page': (_) => const HomePage(),
  'Practice Mode': (_) => const PracticeMode(),
  'Assignment Mode': (_) => const AssignmentMode(),
  //'LogIn Page': (_) => const LogInPage(),
  'Profile Page': (_) => const ProfilePage(),
  'User Page': (_) => const EditUserPage(),
  'Language Page': (_) => const LanguagePage(),
  'Qualification Page': (_) => const QualificationPage(),
  'Topic Page': (_) => const TopicPage(),
  'Question Page': (_) => const QuestionPage(),
};
final _availableDesktopPages = <String, WidgetBuilder>{
  //'Home Page': (_) => const DesktopHomePage(),
  'Practice Mode': (_) => const DesktopPracticeMode(),
  'Assignment Mode': (_) => const DesktopAssignmentMode(),
  //'LogIn Page': (_) => const LogInPage(),
  'Profile Page': (_) => const ProfilePageDesktop(),
  'User Page': (_) => const EditUserDesktopPage(),
  'Language Page': (_) => const LanguageDesktopPage(),
  'Qualification Page': (_) => const QualificationDesktopPage(),
  'Topic Page': (_) => const TopicDesktopPage(),
  'Question Page': (_) => const QuestionDesktopPage(),
};
// Profile
final navigatorKey = GlobalKey<NavigatorState>();

enum Page { screenQuestions, screenAnalytics, manageUsers, language, topic, question, level }

final Map<Page, Widget> fragments = {
  Page.screenQuestions: const MyQuestionsPage(),
  Page.screenAnalytics: const MyAnalyticsPage(),
  Page.manageUsers: const ManageUserPage(),
  Page.language: const LanguageEditPage(),
  Page.topic: const TopicEditPage(),
  Page.question: const QuestionEditPage(),
  Page.level: const LevelEditPage(),
};

// this is a `StateProvider` so we can change its value
final selectedPageNameProvider = StateProvider<String>((ref) {
  // default value
  return _availablePages.keys.first;
});
void selectPage(WidgetRef ref, BuildContext context, String pageName) {
  // only change the state if we have selected a different page
  if (ref.read(selectedPageNameProvider.state).state != pageName) {
    ref.read(selectedPageNameProvider.state).state = pageName;
  }
}

final selectedPageBuilderProvider = Provider<WidgetBuilder>((ref) {
  // watch for state changes inside selectedPageNameProvider
  final selectedPageKey = ref.watch(selectedPageNameProvider.state).state;
  // return the WidgetBuilder using the key as index
  return _availablePages[selectedPageKey]!;
});
final selectedMobilePageBuilderProvider = Provider<WidgetBuilder>((ref) {
  // watch for state changes inside selectedPageNameProvider
  final selectedPageKey = ref.watch(selectedPageNameProvider.state).state;
  // return the WidgetBuilder using the key as index
  return _availableMobilePages[selectedPageKey]!;
});
final selectedDesktopPageBuilderProvider = Provider<WidgetBuilder>((ref) {
  // watch for state changes inside selectedPageNameProvider
  final selectedPageKey = ref.watch(selectedPageNameProvider.state).state;
  // return the WidgetBuilder using the key as index
  return _availableDesktopPages[selectedPageKey]!;
});

// * providers
final titleProvider = Provider<String>((ref) {
  String title = 'Home Page';
  title = ref.watch(selectedPageNameProvider.state).state;
  return title;
});

// * Auth Providers
final firebaseAuthProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);
final userStateProvider = StateNotifierProvider<UserStateNotifier, MyUserData?>(
  (_) => UserStateNotifier(_.read)..appInit(),
);

// * App Providers
final languageStateProvider = StateNotifierProvider<Languages, Map<String, Language>>((ref) => Languages());
final qualificationStateProvider = StateNotifierProvider<Qualifications, Map<String, Qualification>>((ref) => Qualifications());
final topicStateProvider = StateNotifierProvider.family<Topics, Map<String, Topic>, String>((ref, ids) {
  List values = ids.split('-');
  return Topics(lan: values[0], level: values[1]);
});

// TODO: delete
final languageProvider = ChangeNotifierProvider<Languages2>((ref) => Languages2());
final qualificationProvider = ChangeNotifierProvider<Qualifications2>((ref) => Qualifications2());
final topicProvider = ChangeNotifierProvider<Topics2>((ref) {
  var lan = ref.watch(languageProvider).getLanguage();
  var level = ref.watch(qualificationProvider).getLevel();
  return Topics2(lan, level);
});

// * Unsorted
final authRepositoryProvider = Provider<AuthService>((_) => AuthService(_.read));
final loginProvider = ChangeNotifierProvider<LoginProvider>((_ref) => LoginProvider());
final questionProvider = ChangeNotifierProvider<Questions>((ref) {
  var topic;
  bool custom = ref.watch(usersProvider).custom ?? false;
  if (!custom) {
    topic = ref.watch(topicProvider).getTopicIds();
  }
  return Questions(topic);
});
final assessmentProvider = ChangeNotifierProvider<AssessmentProvider>((ref) {
  var questions = ref.watch(questionProvider);
  if (questions.items.isNotEmpty) {
    return AssessmentProvider(questions.getAssignmentLists());
  } else {
    return AssessmentProvider({});
  }
});
final answerProvider = ChangeNotifierProvider.family((ref, bool custom) {
  dynamic uid;
  if (!custom) {
    uid = ref.watch(userStateProvider)?.authData;
  } else {
    uid = ref.watch(usersProvider).currentUser;
  }
  return Answers(uid.uid);
});
final usersProvider = ChangeNotifierProvider((ref) => Users());
