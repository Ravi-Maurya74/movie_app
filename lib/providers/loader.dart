import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/providers/user.dart';
import 'package:provider/provider.dart';

class Loader {
  late Completer<int> ch;
  List<Response> data = [];
  Loader() {
    // print('started');
    ch = Completer();
    start();
  }
  Future<int> get choice {
    return ch.future;
  }

  void start() async {
    final box = GetStorage();
    bool hasUser = box.hasData('user_id');
    if (hasUser) {
      int user_id = box.read('user_id');
      final results = await Future.wait([
        NetworkHelper().getData(url: 'identifyUser/$user_id'),
        NetworkHelper().getData(url: 'genre/'),
        NetworkHelper().getData(url: 'topRatedMovies/'),
        NetworkHelper().getData(url: 'mostUpvotedMovies/'),
      ]);
      data = results;
      ch.complete(1);
      print('completed');
      String firstMovie = jsonDecode(results[2].body)[0]['imageUrl'];
      Image image = Image(
        image: CachedNetworkImageProvider(firstMovie),
        fit: BoxFit.cover,
      );
      loadImage(image.image);
    } else {
      ch.complete(2);
    }
  }
}

Future<void> loadImage(ImageProvider provider) {
  final config = ImageConfiguration(
    bundle: rootBundle,
    devicePixelRatio: window.devicePixelRatio,
    platform: defaultTargetPlatform,
  );
  final Completer<void> completer = Completer();
  final ImageStream stream = provider.resolve(config);

  late final ImageStreamListener listener;

  listener = ImageStreamListener((ImageInfo image, bool sync) {
    debugPrint("Image ${image.debugLabel} finished loading");
    completer.complete();
    stream.removeListener(listener);
  }, onError: (dynamic exception, StackTrace? stackTrace) {
    completer.complete();
    stream.removeListener(listener);
    FlutterError.reportError(FlutterErrorDetails(
      context: ErrorDescription('image failed to load'),
      library: 'image resource service',
      exception: exception,
      stack: stackTrace,
      silent: true,
    ));
  });

  stream.addListener(listener);
  return completer.future;
}
