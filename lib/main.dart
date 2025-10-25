import 'package:flame/game.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:new_flame_splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NewSplashScreen game;
  late FlameSplashController controller;
  @override
  void initState() {
    super.initState();
    game = NewSplashScreen();

    controller = FlameSplashController(
      fadeInDuration: Duration(seconds: 1),
      fadeOutDuration: Duration(milliseconds: 250),
      waitDuration: Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlameSplashScreen(
        controller: controller,
        theme: FlameSplashTheme.dark,
        onFinish: (value) {
          GameWidget(game: game);
        },
        showAfter: (context) => GameWidget(game: game),
      ),
    );
  }
}
