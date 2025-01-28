import 'package:flutter/cupertino.dart';
import 'package:heroicons/heroicons.dart';
import 'package:somegame/components/countdown.dart';
import 'package:somegame/push_notifications_manager.dart';
import 'package:somegame/services/auth.dart';
import 'package:somegame/routes.dart';
import 'package:somegame/theme.dart';
import 'package:somegame/components/button_icon.dart';
import 'package:somegame/components/button_text.dart';
import 'package:somegame/components/tag.dart';
import 'package:somegame/models/game.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Stat Counter
class StatCounter extends StatelessWidget {
  final Color _textcolor;
  final String _number;
  final String _label;
  StatCounter(this._textcolor, this._number, this._label);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _number.length < 4 ? (SpacingXXL + 20) : (_number.length * SpacingXS + 13),
            child: Text(
              _number,
              style: Headline3TextStyle.copyWith(color: _textcolor),
            ),
          ),

          Text(
            _label.toUpperCase(),
            style: Subtitle2TextStyle.copyWith(color: _textcolor),
          ),
        ],
      ),
    );
  }
}

// CardGame
class CardGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return ScopedModelDescendant<Game>(
        builder: (BuildContext context, Widget? child, Game game) {

      if(game.state == GameState.ended) {
        PushNotificationsManager.getInstance().unsubscribeFromGame(game);
      }

      return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.GameDetailRoute, arguments: game);
          },
          onLongPress: game.state != GameState.waiting ? null : () {
            _showActionSheet(context, game);
          },
          child: Container(
            height: 256.0,
            padding: EdgeInsets.all(SpacingM),
            decoration: BoxDecoration(
              gradient: backgroundGradient(game),
              borderRadius: BorderRadius.all(
                Radius.circular(RadiusBig),
              ),
              boxShadow: [cardShadow(game)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      game.isCreator
                          ? t.game_card_creator_own
                          : t.game_card_creator_other(game.creator!.name),
                      style: Body1TextStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor(game),
                      ),
                    ),
                    Spacer(),
                    Tag(tagColor(game), textColor(game), tagText(game, t)),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (game.state == GameState.running)
                          Countdown(game, (_, countdown) {
                            return StatCounter(
                              textColor(game),
                              countdown,
                              t.game_label_remaining_time
                            );
                          }),
                        if (game.state != GameState.running)
                          StatCounter(
                            textColor(game),
                            game.intervalAsString(),
                            t.game_label_timeframe
                          ),
                        Container(
                          padding: EdgeInsets.only(left: SpacingM),
                          child: StatCounter(textColor(game),
                              game.usersCount.toString(), t.game_label_player_number),
                        )
                      ],
                    ),
                    Visibility(
                      // buttons are only visible, if i am the creator and game is not running
                      visible: (game.state == GameState.waiting && game.isCreator),
                      child: Container(
                        padding: EdgeInsets.only(top: SpacingS),
                        child: game.usersCount == 1 ? ButtonText(t.button_invite_friends, onTap: () => game.share(t), icon: HeroIcons.userPlus) : Row(
                          children: [
                            Expanded(
                              child: ButtonText(
                                t.button_start_game,
                                onTap: () {
                                  game.update({
                                    'state': GameState.running.index,
                                    'startsAt': DateTime.now()
                                  }).then((value) =>
                                    // add timeout to not get start push notification
                                    Future.delayed(Duration(seconds: 3), () => PushNotificationsManager.getInstance().subscribeToGame(game))
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: SpacingXS),
                            ButtonIcon(
                              HeroIcons.userPlus,
                              onTap: () => game.share(t),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ));
    });
  }

  Gradient backgroundGradient(Game g) {
    Gradient res = DarkGradient;
    if (g.state == GameState.waiting) {
      res = SecondaryGradient;
    } else if (g.state == GameState.ended) {
      res = g.winnerId == AuthService().currentUser!.id ? PrimaryGradient : TertiaryGradient;
    }
    return res;
  }

  Color textColor(Game g) {
    return g.state == GameState.waiting ? TextColorDark : TextColorLight;
  }

  Color tagColor(Game g) {
    Color res = DarkGray;
    if (g.state == GameState.waiting) {
      res = Color(0x4DFFFFFF);
    } else if (g.state == GameState.ended) {
      res = Color(0x1FFFFFFF);
    }
    return res;
  }

  BoxShadow cardShadow(Game g) {
    BoxShadow res = ShadowBigBlack;
    if (g.state == GameState.waiting) {
      res = ShadowBigSecondary;
    } else if (g.state == GameState.ended) {
      res = g.winnerId == AuthService().currentUser!.id ? ShadowBigPrimary : ShadowBigTertiary;
    }
    return res;
  }

  String tagText(Game g, t) {
    String res = t.game_card_status_running;
    if (g.state == GameState.waiting) {
      res = t.game_card_status_waiting;
    } else if (g.state == GameState.ended) {
      res = g.winnerId == AuthService().currentUser!.id ? t.game_card_status_won : t.game_card_status_lost;
    }
    return res;
  }

  Future<void> _showActionSheet(BuildContext context, Game game) async {
    var t = AppLocalizations.of(context)!;
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: Text(game.isCreator ? t.action_sheet_delete_game_title : t.action_sheet_leave_game_title),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _showDeleteConfirm(context, game);
            },
            child: Text(game.isCreator ? t.action_sheet_delete_game_button : t.action_sheet_leave_game_button),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text(t.button_cancel),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirm(BuildContext context, Game game) async {
    var t = AppLocalizations.of(context)!;
    return showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(game.isCreator ? t.overlay_delete_game_title : t.overlay_leave_game_title),
        content: Text(game.isCreator ? t.overlay_delete_game_body : t.overlay_leave_game_body),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text(t.button_no),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              game.deleteOrLeave();
            },
            child: Text(t.button_yes),
          ),
        ],
      ),
    );
  }
}
