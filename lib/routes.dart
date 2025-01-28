import 'package:flutter/widgets.dart';
import 'package:somegame/screens/game_detail.dart';
import 'package:somegame/screens/home.dart';
import 'package:somegame/screens/registration.dart';
import 'package:somegame/screens/create_game.dart';

class Routes {
  static const String LoginRoute = "/";
  static const String RegistrationRoute = "/registration";
  static const String HomeRoute = "/home";
  static const String CreateGameRoute = "/createGame";
  static const String GameDetailRoute = "/gameDetail";

  static Map<String, WidgetBuilder> build() {
    return {
      CreateGameRoute: (context) => CreateGame(),
      RegistrationRoute: (context) => Registration(),
      HomeRoute: (context) => Home(),
      GameDetailRoute: (context) => GameDetail(),
    };
  }
}
