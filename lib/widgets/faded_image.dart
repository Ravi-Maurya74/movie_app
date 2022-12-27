import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class FadedImage extends StatelessWidget {
  const FadedImage({
    Key? key,
    required this.height,
    required this.fadeHeight,
    required this.url,
  }) : super(key: key);

  final String url;
  final double height;
  final double fadeHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: CachedNetworkImage(
            imageUrl: url,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress),
            ),
            errorWidget: (context, url, error) {
              return Image.asset('default.jpg');
            },
            height: height,
            fit: BoxFit.fitHeight,
          ),
        ),
        SizedBox(
          height: height + 1,
          child: Column(
            children: [
              Spacer(),
              Container(
                height: fadeHeight,
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
