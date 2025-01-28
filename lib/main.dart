import 'dart:async';

import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:somegame/purchase_observer.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:provider/provider.dart';
import 'package:somegame/push_notifications_manager.dart';
import 'package:somegame/services/auth.dart';
import 'package:somegame/theme.dart';
import 'package:somegame/routes.dart';
import 'package:somegame/screens/home.dart';

import 'models/user.dart';

final Logger _log = Logger('main');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterBranchSdk.init();

  PurchasesObserver().initialize();

  PrintAppender.setupLogging(level: Level.FINE);

  // required for device orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  late StreamSubscription _deepLinksSub;
  late StreamSubscription _waitForSignUpSub;
  String? invitedToGameId;

  final purchasesObserver = PurchasesObserver();

  void subscribeToDeepLinks() async {
    _deepLinksSub = FlutterBranchSdk.listSession().listen((data) {
      if (data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) {
        joinGame(data["id"]);
      }
    });
  }

  void joinGame(String gameId) {
    _log.info({'msg': 'deepLink', 'action': 'joinGame', 'gameId': gameId});
    final currentUser = AuthService().currentUser;

    if(currentUser != null) {
      // reload Home state to show invitation screen
      setState(() {
        invitedToGameId = gameId;
      });
    } else {
      _waitForSignUpSub = AuthService().userChanges.listen((u) {
        if(u != null && u.name.isNotEmpty) {
          // reload Home state to show invitation screen
          setState(() {
            invitedToGameId = gameId;
          });
          _waitForSignUpSub.cancel();
        }
      });
    }
  }

  @override
  void initState() {
    _log.fine({'msg': 'initState'});
    subscribeToDeepLinks();
    super.initState();

    subscribeAdaptyForEvents();
    // FlutterBranchSdk.validateSDKIntegration();
    // test joinCame with current user
    // joinGame("O935IxrBhIDKltnMx9Mz");
    // test joinGame with new user
    // AuthService().signOut().then((value) => joinGame("sCPFqKAwPhb6QXD5dUgl"));
  }

  @override
  void dispose() {
    _log.fine({'msg': 'dispose'});
    _deepLinksSub.cancel();
    _waitForSignUpSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey =
        new GlobalKey<NavigatorState>();
    PushNotificationsManager.getInstance().init(navigatorKey);

    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        routes: Routes.build(),
        title: 'AppName',
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('de'), // German
        ],
        navigatorKey: navigatorKey,
        theme: ThemeData(
          textTheme: TextTheme(
            displayLarge: Headline1TextStyle,
            displayMedium: Headline2TextStyle,
            displaySmall: Headline3TextStyle,
            headlineMedium: ButtonTextStyle,
            bodyLarge: Body1TextStyle,
            bodyMedium: Body2TextStyle,
            titleMedium: Subtitle1TextStyle,
            titleSmall: Subtitle2TextStyle,
            )
        ),
        home: Home(gameId: invitedToGameId),
      ),
    );

  }

  Future<void> _showErrorDialog(String title, String message, String? details) {
    return showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Column(
          children: [
            Text(message),
            if (details != null) Text(details),
          ],
        ),
        actions: [
          CupertinoButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }

  void subscribeAdaptyForEvents() {
    purchasesObserver.onAdaptyErrorOccurred = (error) {
      if (error.code == AdaptyErrorCode.paymentCancelled) return;

      _showErrorDialog('Adapty Error ${error.code}', error.message, error.detail);
    };

    purchasesObserver.onUnknownErrorOccurred = (error) {
      _showErrorDialog('Unknown Error', error.toString(), null);
    };

    Adapty().didUpdateProfileStream.listen((profile) {
      purchasesObserver.setProfile(profile);
    });
  }
}
