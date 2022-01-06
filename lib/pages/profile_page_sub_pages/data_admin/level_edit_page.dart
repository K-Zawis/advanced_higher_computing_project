import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';

class LevelEditPage extends ConsumerStatefulWidget {
  const LevelEditPage({Key? key}) : super(key: key);

  @override
  _LevelEditPageState createState() => _LevelEditPageState();
}

class _LevelEditPageState extends ConsumerState<LevelEditPage> {

  double _bottom = 16.0;

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              setState(() {
                _bottom = 16.0;
              });
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              setState(() {
                _bottom = -100.0;
              });
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var qualifications = ref.watch(qualificationProvider).items;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 850,
            ),
            child: NotificationListener(
              onNotification: _handleScrollNotification,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 50),
                physics: const BouncingScrollPhysics(),
                itemCount: qualifications.length,
                itemBuilder: (context, index) {
                  var qualification = qualifications.values.toList()[index];
                  return ListTile(
                    title: Text(
                      qualification.level,
                      style: const TextStyle(
                        color: textColour,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          color: hintColour,
                          tooltip: 'Delete',
                          onPressed: () {
                            ref.read(qualificationProvider).removeDocument(qualification.id);
                          },
                          icon: const Icon(
                            Icons.delete,
                          ),
                        ),
                        IconButton(
                          color: iconColour,
                          tooltip: 'Edit',
                          onPressed: () {
                            ref.read(qualificationProvider).setQualification(qualification);
                            selectPage(ref, context, 'Qualification Page');
                          },
                          icon: const Icon(
                            Icons.edit,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          bottom: _bottom,
          right: 20,
          duration: const Duration(milliseconds: 500),
          child: FloatingActionButton(
            onPressed: () {
              ref.read(qualificationProvider).setQualification(null);
              selectPage(ref, context, 'Qualification Page');
            },
            tooltip: 'Add Qualification',
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}