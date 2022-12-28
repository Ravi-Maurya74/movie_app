import 'package:flutter/material.dart';

class AnimatedMenu extends StatefulWidget {
  const AnimatedMenu({super.key});

  @override
  State<AnimatedMenu> createState() => _AnimatedMenuState();
}

class _AnimatedMenuState extends State<AnimatedMenu>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _expanded = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() {
            _expanded ? _controller.forward() : _controller.reverse();
            if (_expanded) {
              Scaffold.of(context).openDrawer();
            }
            _expanded = !_expanded;
          });
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _controller,
        ));
  }
}
