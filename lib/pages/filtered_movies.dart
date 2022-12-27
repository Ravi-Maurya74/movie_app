import 'package:flutter/material.dart';

class FilteredMovies extends StatelessWidget {
  static const routeName = '/filtered';
  const FilteredMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 50),
          child: Column(
            children: [
              CustomAppbar(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Text(
              'Results',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '12 Found',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }
}
