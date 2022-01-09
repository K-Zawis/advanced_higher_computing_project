import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_languages/constants.dart';

class LanguageEditPage extends ConsumerStatefulWidget {
  const LanguageEditPage({Key? key}) : super(key: key);

  @override
  _LanguageEditPageState createState() => _LanguageEditPageState();
}

class _LanguageEditPageState extends ConsumerState<LanguageEditPage> {
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
    var languages = ref.watch(languageProvider).items;
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
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  var language = languages.values.toList()[index];
                  return ListTile(
                    title: Text(
                      language.language,
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
                            _showDialog(ref, context, language);
                          },
                          icon: const Icon(
                            Icons.delete,
                          ),
                        ),
                        IconButton(
                          color: iconColour,
                          tooltip: 'Edit',
                          onPressed: () {
                            ref.read(languageProvider).setCurrentLanguage(language);
                            selectPage(ref, context, 'Language Page');
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
              ref.read(languageProvider).setCurrentLanguage(null);
              selectPage(ref, context, 'Language Page');
            },
            tooltip: 'Add Language',
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  _showDialog(WidgetRef ref, BuildContext context, language) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning!"),
          content: const Text('All topics and questions linked to this Language will be deleted.\n\nProceed?'),
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
              child: const Text('Delete'),
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
                ref.read(languageProvider).removeDocument(language.id);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
