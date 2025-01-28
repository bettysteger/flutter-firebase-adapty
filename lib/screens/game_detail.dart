import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';
import 'package:logging/logging.dart';
import 'package:somegame/components/modal_sheet.dart';
import 'package:somegame/models/game.dart';
import 'package:somegame/push_notifications_manager.dart';
import 'package:somegame/screens/member_list.dart';
import 'package:somegame/services/auth.dart';
import 'package:somegame/theme.dart';
import 'package:somegame/components/button_text.dart';
import 'package:somegame/components/button_icon.dart';
import 'package:somegame/components/components.dart';
import 'package:somegame/components/countdown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final Logger _log = Logger('game_detail');

class GameDetail extends StatefulWidget {
  GameDetail({Key? key}) : super(key: key);

  @override
  State<GameDetail> createState() => GameDetailState();
}

class GameDetailState extends State<GameDetail> {
  final String currentUserId = AuthService().currentUser!.id;
  late Game _game;

  @override
  void initState() {
    _log.fine({'msg': 'initState'});
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.initState();
  }

  @override
  void dispose() {
    _log.fine({'msg': 'dispose'});
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    _game = ModalRoute.of(context)!.settings.arguments as Game;
    _log.fine({'msg': 'build', 'game': _game.toString()});
    var t = AppLocalizations.of(context)!;

    return StreamBuilder<Game>(
      stream: _game.gameStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(backgroundColor: ExtralightGray, color: LightGray));
        }
        final game = snapshot.data!;
        return ScopedModel<Game>(
          model: game,
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                    SpacingXL,
                    SpacingHuge,
                    SpacingXL,
                    SpacingXL,
                  ),
                  decoration: _boxDecoration(game),
                  child: ScopedModelDescendant<Game>(
                      builder: (context, child, model) {
                    return Column(
                      children: [
                        Spacer(),
                        if (game.state == GameState.waiting)
                          ContentOnLight(
                            '😴',
                            model.isCreator ? t.waiting_title_game_own1 : t.waiting_title_game_other1(model.creator!.name),
                            t.waiting_title_game2,
                            model.isCreator
                                ? t.waiting_body_game_own
                                : t.waiting_body_game_other(model.creator!.name),
                            model.intervalAsString(),
                            t.game_label_timeframe,
                            model.usersCount.toString(),
                            t.game_label_player_number
                          ),
                        if (game.state == GameState.running)
                          Countdown(game, (_, countdown) {
                            return ContentOnDark(
                              '🤞',
                              t.running_title1,
                              t.running_title2,
                              t.running_body,
                              countdown,
                              t.game_label_remaining_time,
                              model.usersCount.toString(),
                              t.game_label_player_number
                            );
                          }),
                        if (game.state == GameState.ended)
                          _buildFinishContent(game, context),
                        Spacer(flex: 2),
                        if (game.state == GameState.waiting && game.isCreator)
                          Container(
                            padding: EdgeInsets.only(top: SpacingS, bottom: SpacingXS),
                            child: game.usersCount == 1 ? ButtonText(t.button_invite_friends, onTap: () => game.share(t), icon: HeroIcons.userPlus) : Row(
                              children: [
                                Expanded(
                                  child: ButtonText(
                                    t.button_start_game,
                                    onTap: () {
                                      model.update({
                                        'state': GameState.running.index,
                                        'startsAt': DateTime.now()
                                      }).then((value) =>
                                        // add timeout to not get start push notification
                                        Future.delayed(Duration(seconds: 3), () => PushNotificationsManager.getInstance().subscribeToGame(model))
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: SpacingXS),
                                  child: ButtonIcon(HeroIcons.userPlus,
                                    onTap: () {
                                      model.share(t);
                                  }),
                                ),
                              ],
                            ),
                          ),
                        if (game.usersCount > 1)
                          ButtonText(
                            game.state == GameState.waiting ? t.waiting_memberlist_btn : (game.state == GameState.running ? t.running_memberlist_btn : t.ended_memberlist_btn),
                            onTap: () => ModalSheet.show(context, MemberList(game: model), t.member_list_title(model.usersCount), false),
                            style: game.state == GameState.waiting ? "outline-primary" : "outline-secondary",
                          ),
                      ],
                    );
                  }),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ScopedModelDescendant<Game>(
                      builder: (context, child, model) {
                    return NavigationBarIconLeft(
                      model.isCreator
                          ? t.game_title_own
                          : t.game_title_other(model.creator!.name),
                      HeroIcons.arrowLeft,
                      game.state == GameState.waiting ? TextColorDark : TextColorLight,
                      onTap: () => Navigator.pop(context),
                    );
                  }),
                ),
              ],
            ),
          )
        );
      });
  }

  ContentOnDark _buildFinishContent(Game game, context) {
    var t = AppLocalizations.of(context)!;
    var diff = _calcPushDiff(game, t);
    final counters = [
      t.game_label_remaining_time,
      game.usersCount.toString(),
      t.game_label_player_number
    ];

    if (game.winnerId == currentUserId) {
      return ContentOnDark(
        '💸',
        t.win_title1,
        t.win_title2,
        t.win_body(diff, game.usersCount - 1),
        '0',
        counters[0], counters[1], counters[2]
      );
    } else if(diff == '?' && game.remainingTime().inSeconds <= 0) {
      return ContentOnDark(
        '💩',
        t.timeout_title1,
        t.timeout_title2,
        t.timeout_body,
        '0',
        counters[0], counters[1], counters[2]
      );
    } else if (_calcPosition(game) == game.usersCount) {
      return ContentOnDark(
        '🤬',
        t.lastplace_title1,
        t.lastplace_title2,
        t.lastplace_body(diff),
        '0',
        counters[0], counters[1], counters[2]
      );
    } else {
      return ContentOnDark(
        '😖',
        t.lost_title1,
        t.lost_title2,
        t.lost_body(diff, _calcPosition(game), game.usersCount),
        '0',
        counters[0], counters[1], counters[2]
      );
    }
  }

  BoxDecoration _boxDecoration(Game game) {
    switch (game.state) {
      case GameState.ended:
        return BoxDecoration(gradient: game.winnerId == currentUserId
                  ? PrimaryGradient
                  : TertiaryGradient);
      case GameState.running:
        return BoxDecoration(color: Colors.black);
      default:
        return BoxDecoration(gradient: SecondaryGradient);
    }
  }

  String _calcPushDiff(Game game, t) {
    var user = game.users!.firstWhere((u) => u.isCurrent);
    var secs = game.pushDifferenceInSecs(user);
    return secs != null ? t.secs(secs) : '?';
  }

  int _calcPosition(Game game) {
    var pushed = game.orderUsersByPushedAt();
    return pushed.indexWhere((user) => user.isCurrent) + 1;
  }

}
