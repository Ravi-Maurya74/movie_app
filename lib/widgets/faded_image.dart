import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class FadedImage extends StatelessWidget {
  const FadedImage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: url,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(value: downloadProgress.progress),
          ),
          errorWidget: (context, url, error) {
            return Image.asset('default.jpg');
          },
          height: 300,
          fit: BoxFit.fitHeight,
        ),
        SizedBox(
          height: 300,
          child: Column(
            children: [
              Spacer(),
              Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color.fromRGBO(24, 25, 32, 1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
