import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie_native/lottie_native.dart';

import 'page_dragger.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lottie'),
        ),
        body: Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyApp();
                  }));
                },
                child: Text('Click'),
              ),
            );
          },
        ),
      ),
    );
  }
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LottieController? controller;
  LottieController? controller2;
  late StreamController<double> newProgressStream;

  _MyAppState() {
    newProgressStream = new StreamController<double>();
  }

  @override
  Widget build(BuildContext context) {
    return PageDragger(
      stream: this.newProgressStream,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lottie'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 150,
                height: 150,
                child: LottieView.fromURL(
                  url:
                  'https://raw.githubusercontent.com/airbnb/lottie-ios/master/Tests/Samples/Watermelon.json',
                  autoPlay: true,
                  loop: true,
                  reverse: true,
                  onViewCreated: onViewCreated,
                ),
              ),
              TextButton(
                child: Text("Play"),
                onPressed: () {
                  controller?.play();
                },
              ),
              TextButton(
                child: Text("Stop"),
                onPressed: () {
                  controller?.stop();
                },
              ),
              TextButton(
                child: Text("Pause"),
                onPressed: () {
                  controller?.pause();
                },
              ),
              TextButton(
                child: Text("Resume"),
                onPressed: () {
                  controller?.resume();
                },
              ),
              Text("From File"),
              Container(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: LottieView.fromAsset(
                    filePath: "animations/newAnimation.json",
                    autoPlay: true,
                    loop: false,
                    repeatCount: 2,
                    onViewCreated: onViewCreatedFile,
                  ),
                ),
              ),
              TextButton(
                child: Text("Change Color"),
                onPressed: () {
                  // Set Color of KeyPath
                  this.controller2?.setValue(
                    value: LOTColorValue.fromColor(
                      color: Color.fromRGBO(0, 0, 255, 1),
                    ),
                    keyPath: "body Konturen.Gruppe 1.Fläche 1",
                  );
                  // Set Opacity of KeyPath
                  this.controller2?.setValue(
                    value: LOTOpacityValue(opacity: .1),
                    keyPath: "body Konturen.Gruppe 1.Fläche 1",
                  );
                },
              ),
              Text("Drag anywhere to change animation progress"),
            ],
          ),
        ),
      ),
    );
  }

  void onViewCreated(LottieController controller) {
    this.controller = controller;

    // Listen for when the playback completes
    controller.onPlayFinished.listen((bool animationFinished) {
      print("wpeng, Anim 1 complete. Was Animation Finished? $animationFinished");
    });
  }

  void onViewCreatedFile(LottieController controller) {
    this.controller2 = controller;
    newProgressStream.stream.listen((double progress) {
      this.controller2?.setAnimationProgress(progress);
    });
    controller.onPlayFinished.listen((bool animationFinished) {
      print("wpeng, Anim 2 complete. Was Animation Finished? $animationFinished");
    });
  }

  void dispose() {
    super.dispose();
    newProgressStream.close();
  }
}
