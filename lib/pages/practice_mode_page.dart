import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_languages/constants.dart';

import '../widget_tree.dart';

class PracticeMode extends StatefulWidget {
  const PracticeMode({Key? key}) : super(key: key);

  @override
  _PracticeModeState createState() => _PracticeModeState();
}

class _PracticeModeState extends State<PracticeMode> with TickerProviderStateMixin {
  final int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 4;
  late AnimationController _animationController;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 450,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            // * image bar
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
                          colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(150, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                            selectPage(context, 'Home Page');
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
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                        padding: const EdgeInsets.only(top: 20),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Container(
                            padding: const EdgeInsets.only(right: 50, left: 50),
                            constraints: const BoxConstraints(
                              maxWidth: 850,
                            ),
                            child: Consumer(builder: (context, watch, child) {
                              var questions = watch(questionProvider);
                              if (questions.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(questions.toString()),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: IconButton(
                                        onPressed: () {
                                          if (!_playing) {
                                            _animationController.forward();
                                            _playing = true;
                                          } else {
                                            _animationController.reverse();
                                            _playing = false;
                                          }
                                        },
                                        icon: AnimatedIcon(
                                          progress: _animationController,
                                          icon: AnimatedIcons.play_pause,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        iconSize: 70,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return CountdownTimer(
                                    endTime: endTime,
                                    widgetBuilder: (context, time) {
                                      if (time == null) {
                                        return Center(
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
                                        );
                                      } else {
                                        return const Padding(
                                          padding: EdgeInsets.only(top: 100),
                                          child: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                    });
                              }
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
