import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learn_languages/constants.dart';
import 'package:learn_languages/models/question_model.dart';
import 'package:learn_languages/widgets/sound_wave_widget.dart';

import '../widget_tree.dart';

class DesktopAssignmentMode extends StatefulWidget {
  const DesktopAssignmentMode({Key? key}) : super(key: key);

  @override
  _DesktopAssignmentModeState createState() => _DesktopAssignmentModeState();
}

class _DesktopAssignmentModeState extends State<DesktopAssignmentMode> with TickerProviderStateMixin {
  final int _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 2;
  late AnimationController _animationController;
  late FlutterTts _flutterTts;
  final ValueNotifier<bool> _playing = ValueNotifier<bool>(false);
  bool _shuffled = false;
  List<Question> _topic1 = [];
  List<Question> _topic2 = [];
  final Map<dynamic, List<dynamic>> _usedQuestions = {};
  final _index = Random().nextInt(1);
  Map<String, List<Question>>? _topicMap;
  String _question = '';
  bool _complete = false;

  void nextQuestion(List<Question> topic) {
    Random rnd = Random();
    _question = '';
    int? index;
    while (_question == '') {
      index = rnd.nextInt(topic.length);
      if (_usedQuestions[topic[index].topic] != null) {
        if (!_usedQuestions[topic[index].topic]!.contains(topic[index].question)) {
          _question = topic[index].question;
        }
      } else {
        _question = topic[index].question;
      }
    }
    _usedQuestions.update(
      topic[index!].topic,
          (list) => list..add(topic[index!].question),
      ifAbsent: () => [topic[index!].question],
    );
  }

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
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            // * image banner
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  SizedBox(
                    height: 250,
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
                            ),
                            IconButton(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              icon: const Icon(
                                Icons.home_filled,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: () {
                                if (_complete) {
                                  selectPage(context, 'Home Page');
                                } else {
                                  _showDialog(context);
                                }
                              },
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
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Consumer(builder: (context, watch, child) {
                  var prov = watch(questionProvider);
                  var questions = prov.items;
                  if (questions.isNotEmpty) {
                    // * only happens once
                    if (!_shuffled) {
                      _topicMap = prov.getAssignmentLists();
                      _topic1 = _topicMap!.values.toList()[0];
                      _topic2 = _topicMap!.values.toList()[1];
                      _topic1.shuffle();
                      _topic2.shuffle();
                      if (_index == 0) {
                        nextQuestion(_topic1);
                      } else {
                        nextQuestion(_topic2);
                      }
                      _shuffled = true;
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
                                  visible: _complete,
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
                                        /*const SizedBox(
                                          height: 30,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            selectPage(context, 'Assignment Mode');
                                          },
                                          icon: const Icon(Icons.replay),
                                          color: Theme.of(context).colorScheme.primary,
                                          iconSize: 80,
                                        ),
                                        Text(
                                          'Replay?',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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
                          visible: !_complete,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    if (!_playing.value) {
                                      await _flutterTts.speak(_question);
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
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await _flutterTts.stop();
                                    if (!(_usedQuestions[_topic1[0].topic]?.length == _topic1.length &&
                                        _usedQuestions[_topic2[0].topic]?.length == _topic2.length)) {
                                      if (_index == 0) {
                                        if (_usedQuestions[_topic1[0].topic]?.length == _topic1.length) {
                                          setState(() {
                                            nextQuestion(_topic2);
                                          });
                                        } else {
                                          setState(() {
                                            nextQuestion(_topic1);
                                          });
                                        }
                                      } else {
                                        if (_usedQuestions[_topic2[0].topic]?.length == _topic2.length) {
                                          setState(() {
                                            nextQuestion(_topic1);
                                          });
                                        } else {
                                          setState(() {
                                            nextQuestion(_topic2);
                                          });
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        _complete = true;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.skip_next,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  iconSize: 70,
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
                        });
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
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
            child: const Text('Cancel', style: TextStyle(color: Colors.red,),),
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
              selectPage(context, 'Home Page');
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}