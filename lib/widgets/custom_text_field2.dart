import 'package:flutter/material.dart';

class CustomTextField2 extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final IconData iconData;
  final String hint;
  const CustomTextField2({
    required this.textEditingController,
    required this.label,
    required this.iconData,
    this.hint = '',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(37, 42, 52, 1),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                iconData,
                color: Colors.white.withOpacity(0.7),
              )),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                // label: Text(label),
                hintText: hint,
                // labelStyle: TextStyle(color: Colors.white),
              ),
              controller: textEditingController,
              autofillHints: gethints(label),
            ),
          ),
        ],
      ),
    );
  }
}

Iterable<String> gethints(String label) {
  if (label == 'Email') {
    return [AutofillHints.email];
  } else if (label == 'Full Name') {
    return [AutofillHints.name];
  } else {
    return [];
  }
}