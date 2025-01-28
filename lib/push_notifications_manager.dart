import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:somegame/services/auth.dart';

import 'models/game.dart';
import 'package:somegame/routes.dart';

final Logger _log = Logger('push_notifications_manager');

class PushNotificationsManager {
  static late PushNotificationsManager _instance;
  late FirebaseMessaging _firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  late GlobalKey<NavigatorState> _navigatorKey;
  late StreamSubscription _waitForGameSub;

  PushNotificationsManager._internal();

  static PushNotificationsManager getInstance() {
    _instance = PushNotificationsManager._internal();
    _instance._firebaseMessaging = FirebaseMessaging.instance;
    return _instance;
  }

  Future<bool> init(GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;
    if(_initialized) { return false; }

    _log.fine({'msg': 'init'});

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    // _firebaseMessaging.getInitialMessage().then(_handleMessage);

    if(Platform.isAndroid) {
      flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        ),
        onDidReceiveNotificationResponse: onSelectNotification
      );
    }

    var bool = true;

    if (Platform.isIOS) {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      bool = settings.authorizationStatus == AuthorizationStatus.authorized;
    }

    _initialized = bool;
    return bool;
  }

  Future<void> subscribeToGame(Game game) async {
    _log.fine({'msg': 'subscribeToTopic', 'topic': game.id});
    return _firebaseMessaging.subscribeToTopic(game.id);
  }

  Future<void> unsubscribeFromGame(Game game) async {
    _log.fine({'msg': 'unsubscribeToTopic', 'topic': game.id});
    return _firebaseMessaging.unsubscribeFromTopic(game.id);
  }

  Future<void> setPushedAtAndUpdateGame(gameId) {
    final game = Game(id: gameId);

    _waitForGameSub = game.gameStream.listen((game) {
      if(game.winnerId != null && game.users!.firstWhere((u) => u.isCurrent).pushedAt != null) {
        if(_navigatorKey.currentState == null) {
          _navigatorKey = new GlobalKey<NavigatorState>();
        }
        _navigatorKey.currentState?.pushNamed(Routes.GameDetailRoute, arguments: game);
        _waitForGameSub.cancel();
      }
    });
    final currentUser = AuthService().currentUser;
    currentUser!.pushedAt = DateTime.now();
    return game.updateUser(currentUser);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    _log.fine({'msg': 'handlePushNotification', 'message': message.data.toString()});

    switch (message.data['type']) {
      case 'gameEnd':
        return setPushedAtAndUpdateGame(message.data['gameId']);
      default:
        _log.shout(
            "Unhandled push notification type $message['type']");
        break;
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && message.data['type'] != 'gameStart') {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails('somegame_game', 'Somegame game',
              importance: Importance.high,
              sound: RawResourceAndroidNotificationSound('notification')
            ),
          ),
          payload: jsonEncode(message.data)
      );
    }
  }

  void onSelectNotification(NotificationResponse response) {
    _log.fine({'msg': 'onSelectNotification', 'payload': response.payload});
    if(response.payload == null) { return; }
    // var data = jsonDecode(payload!);
    // if(data['type'] == 'gameEnd') {
    //   return setPushedAtAndUpdateGame(data['gameId']);
    // }
    // return Future.value();
  }

  Future<String?> getToken() {
    return _firebaseMessaging.getToken();
  }

}
