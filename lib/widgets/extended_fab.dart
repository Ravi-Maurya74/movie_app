import 'package:flutter/material.dart';

class ExtendedFAB extends StatefulWidget {
  final ScrollController scrollController;
  final String label;
  final IconData iconData;
  const ExtendedFAB(
      {required this.iconData,
      required this.label,
      required this.scrollController,
      super.key});

  @override
  State<ExtendedFAB> createState() => _ExtendedFABState();
}

class _ExtendedFABState extends State<ExtendedFAB> {
  double _offset = 0;
  bool extended = true;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.scrollController.hasClients) {
        _offset = widget.scrollController.offset;
        widget.scrollController.addListener(_setOffset);
      }
    });
  }

  @override
  dispose() {
    widget.scrollController.removeListener(_setOffset);
    super.dispose();
  }

  void _setOffset() {
    _offset = widget.scrollController.offset;

    setState(() {
      extended = _offset < 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear,
      height: 50,
      width: extended
          ? _textSize(widget.label, Theme.of(context).textTheme.bodyMedium!,
                      context)
                  .width +
              50
          : 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [
          Color.fromRGBO(147, 58, 241, 1),
          Color.fromRGBO(193, 81, 166, 1),
          Color.fromRGBO(247, 109, 78, 1),
          // Theme.of(context).colorScheme.primary
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(13),
      ),
      child: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.transparent,
        isExtended: extended,
        onPressed: () {},
        label: Text(widget.label),
        icon: Icon(widget.iconData),
      ),
    );
  }
}

Size _textSize(String text, TextStyle style, BuildContext context) {
  final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr)
    ..layout();
  return textPainter.size;
}
