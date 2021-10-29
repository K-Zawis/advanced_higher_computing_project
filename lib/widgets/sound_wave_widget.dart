import 'package:flutter/material.dart';

class VisualComponent extends StatefulWidget {
  final int duration;

  const VisualComponent({
    required this.duration,
    Key? key}) : super(key: key);

  @override
  _VisualComponentState createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animController;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration,
      ),
    );
    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeInOutCubic,
    );

    animation = Tween<double>(begin: 10, end: 100).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    animController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: animation.value,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  @override
  void dispose(){
    animController.dispose();
    super.dispose();
  }
}

class SoundWave extends StatelessWidget {
  SoundWave({Key? key}) : super(key: key);
  final List<int> duration = [300, 700, 500, 900, 600];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(
        6,
        (index) => VisualComponent(
          duration: duration[index % 5],
        ),
      ),
    );
  }
}
