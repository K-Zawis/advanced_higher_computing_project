import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learn_languages/constants.dart';
import 'package:learn_languages/models/question_model.dart';
import 'package:learn_languages/widgets/sound_wave_widget.dart';

import '../widget_tree.dart';

class AssignmentMode extends StatefulWidget {
  const AssignmentMode({Key? key}) : super(key: key);

  @override
  _AssignmentModeState createState() => _AssignmentModeState();
}

class _AssignmentModeState extends State<AssignmentMode> with TickerProviderStateMixin {
  final int _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 2;
  late AnimationController _animationController;
  late FlutterTts _flutterTts;
  final ValueNotifier<bool> _playing = ValueNotifier<bool>(false);
  Map<String, List<Question>>? _topicMap;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 450,
      ),
    );
    initTts();
    super.initState();
  }

  initTts() {
    _flutterTts = FlutterTts();
    _flutterTts
        .setLanguage(context.read(languageProvider).items[context.read(languageProvider).getLanguage()]!.ISOcode);

    // TODO -- find out why stop() doesn't work in safari and how to fix it
    _flutterTts.setCancelHandler(() {
      _animationController.reverse();
      setState(() {
        _playing.value = false;
      });
    });
    _flutterTts.setPauseHandler(() {
      _animationController.reverse();
      setState(() {
        _playing.value = false;
      });
    });
    _flutterTts.setContinueHandler(() {
      _animationController.forward();
      setState(() {
        _playing.value = true;
      });
    });
    _flutterTts.setCompletionHandler(() {
      _animationController.reverse();
      setState(() {
        _playing.value = false;
      });
    });
    _flutterTts.setStartHandler(() {
      _animationController.forward();
      setState(() {
        _playing.value = true;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      var assessment = watch(assessmentProvider);
      var _usedQuestions = assessment.getUsedQuestions();
      return Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              // * image banner
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: double.infinity,
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/learn-languages-71bed.appspot.com/o/pexels-lilartsy-1925536.jpg?alt=media&token=df33a026-149b-46fb-b291-d57eb5e8c0d3',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        height: 80,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 0, 0, 0),
                              Color.fromARGB(150, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                tooltip: 'Menu',
                              ),
                              IconButton(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                icon: const Icon(
                                  Icons.home_filled,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                onPressed: () {
                                  if (assessment.getCompleteStatus()) {
                                    assessment.reset();
                                    selectPage(context, 'Home Page');
                                  } else {
                                    _showDialog(context);
                                  }
                                },
                                tooltip: 'Home Page',
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: SizedBox(
                                  height: 52,
                                  width: 100,
                                  child: Consumer(builder: (context, watch, child) {
                                    var prov = watch(languageProvider);
                                    var language = prov.items[prov.getLanguage()];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0x451C1C1C),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            language!.ISOcode,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'ASSIGNMENT MODE',
                            style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // * body
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Consumer(builder: (context, watch, child) {
                    var prov = watch(questionProvider);
                    var questions = prov.items;
                    if (questions.isNotEmpty) {
                      // * only happens once
                      if (!assessment.getShuffledStatus()) {
                        assessment.nextQuestion(assessment.getTopic(), true);
                        assessment.setShuffledStatus(true);
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration:
                                  const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                              padding: const EdgeInsets.only(top: 50),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Container(
                                  padding: const EdgeInsets.only(right: 20, left: 20),
                                  constraints: const BoxConstraints(
                                    maxWidth: 850,
                                  ),
                                  child: Visibility(
                                    visible: assessment.getCompleteStatus(),
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.network(
                                            'https://firebasestorage.googleapis.com/v0/b/learn-languages-71bed.appspot.com/o/medal_icon.png?alt=media&token=d981c36e-6b33-4d2a-8783-b564ab439b7e',
                                            //color: textColour,
                                            height: 200,
                                            //colorBlendMode: BlendMode.srcIn,
                                          ),
                                          Text(
                                            'CONGRATULATIONS!',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'You have completed Assignment Mode!',
                                            style: TextStyle(
                                              color: textColour,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          const Text(
                                            "Here's how you did:",
                                            style: TextStyle(
                                              color: textColour,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          // TODO -- set numbers to be purple
                                          Text(
                                            'You have skipped ${assessment.getSkipped().length} questions.',
                                            style: const TextStyle(
                                              color: textColour,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'You have played each question on average:',
                                            style: TextStyle(
                                              color: textColour,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'in Topic 1: ${(assessment.getUsedQuestions().values.toList()[0].map((e) => e.played).toList().reduce((value, element) => value + element) / assessment.getUsedQuestions().values.toList()[0].length).toStringAsFixed(2)} times',
                                            style: const TextStyle(
                                              color: textColour,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            assessment.getUsedQuestions().values.length == 2
                                                ? 'in Topic 2: ${(assessment.getUsedQuestions().values.toList()[1].map((e) => e.played).toList().reduce((value, element) => value + element) / assessment.getUsedQuestions().values.toList()[1].length).toStringAsFixed(2)} times'
                                                : '',
                                            style: const TextStyle(
                                              color: textColour,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'You have played:',
                                            style: TextStyle(
                                              color: textColour,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: assessment.getSortedPlayed().length,
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.6,
                                                      child: Text(
                                                        assessment.getSortedPlayed()[index].question.trim(),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.primary,
                                                        ),
                                                      ),
                                                    ),
                                                    Text('${assessment.getSortedPlayed()[index].played} times'),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                              '${assessment.getQuestion()?.question ?? 'N/A'}, ${assessment.getQuestion()?.played ?? 'N/A'}'),
                          ValueListenableBuilder(
                            valueListenable: _playing,
                            builder: (BuildContext context, bool value, Widget? child) {
                              return Visibility(
                                visible: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 50),
                                  child: Container(
                                    width: 80,
                                    constraints: const BoxConstraints(
                                      minHeight: 120,
                                    ),
                                    child: SoundWave(),
                                  ),
                                ),
                              );
                            },
                          ),
                          Visibility(
                            visible: !assessment.getCompleteStatus(),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      if (!_playing.value) {
                                        assessment.setPlayed();
                                        await _flutterTts.speak(assessment.getQuestion()?.question ?? '');
                                      } else {
                                        await _flutterTts.stop();
                                      }
                                    },
                                    icon: AnimatedIcon(
                                      progress: _animationController,
                                      icon: AnimatedIcons.play_pause,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    iconSize: 70,
                                    tooltip: _playing.value ? 'Stop' : 'Play',
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      if (!_playing.value) {
                                        await _flutterTts.stop();
                                        assessment.setPlayed();
                                        assessment.nextQuestion(assessment.getTopic(), false);
                                      }
                                    },
                                    iconSize: 70,
                                    icon: Icon(
                                      Icons.fast_forward,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    tooltip: 'Next',
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await _flutterTts.stop();
                                      assessment.setSkipped();
                                      assessment.nextQuestion(assessment.getTopic(), false);
                                    },
                                    icon: Icon(
                                      Icons.skip_next,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    iconSize: 70,
                                    tooltip: 'Skip',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return CountdownTimer(
                        endTime: _endTime,
                        widgetBuilder: (context, time) {
                          if (time == null) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(50),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/learn-languages-71bed.appspot.com/o/data-not-found-1965034-1662569.png?alt=media&token=a13358ff-8ade-4b2b-855a-22756dba91d8',
                                      color: textColour,
                                      height: 200,
                                      colorBlendMode: BlendMode.srcIn,
                                    ),
                                    const Text(
                                      'No Data Found',
                                      style: TextStyle(
                                        color: textColour,
                                        fontSize: 25,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'No questions were found in this topic, try again later or pick a different topic',
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Center(child: FittedBox(child: CircularProgressIndicator())),
                              ),
                            );
                          }
                        },
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

_showDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Warning!"),
        content: const Text('Your progress will not be saved.\nAre you sure you want to continue?'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Theme.of(context).brightness == Brightness.light
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.2)),
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: const Text('Home'),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            onPressed: () {
              context.read(assessmentProvider).reset();
              selectPage(context, 'Home Page');
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
