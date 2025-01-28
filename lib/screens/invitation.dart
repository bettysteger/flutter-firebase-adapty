import 'package:flutter/material.dart';
import 'package:somegame/models/game.dart';
import 'package:somegame/routes.dart';
import 'package:somegame/services/pro.dart';
import 'package:somegame/theme.dart';
import 'package:somegame/components/button_text.dart';
import 'package:somegame/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';

final Logger _log = Logger('invitation');
class Invitation extends StatefulWidget {
  final String gameId;
  Invitation({required this.gameId, Key? key}) : super(key: key);

  @override
  State<Invitation> createState() => InvitationState();
}

class InvitationState extends State<Invitation> {

  @override
  Widget build(BuildContext context) {
    _log.fine({'msg': 'build', 'gameId': widget.gameId});
    var t = AppLocalizations.of(context)!;
    var _game = new Game(id: widget.gameId);

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
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Spacer(),
                      if(game.state == GameState.waiting)
                        ContentOnLight(
                          '',
                          t.invitation_headline1(game.creator!.name),
                          t.invitation_headline2,
                          t.invitation_body(game.intervalAsString()),
                          game.intervalAsString(),
                          t.game_label_timeframe,
                          game.usersCount.toString(),
                          t.game_label_player_number
                        ),
                      if(game.state != GameState.waiting)
                        ContentOnLight(
                          '',
                          t.invitation_expired_headline1,
                          t.invitation_expired_headline2,
                          t.invitation_expired_body(game.creator!.name),
                          '', '', '', ''
                        ),
                      Spacer(flex: 2),
                      ButtonText(game.state == GameState.waiting ? t.button_decline_invitation : t.invitation_expired_button,
                        style: "secondary",
                        onTap:() => Navigator.pushNamed(context, Routes.HomeRoute)
                      ),
                      SizedBox(height: SpacingXS),
                      if(game.state == GameState.waiting)
                        ButtonText(t.button_accept_invitation, onTap:() async {
                          // add paywall check here, if more than 1 game is running at the same time, we need to check if user is pro
                          bool canPlay = await ProService().canPlay();
                          if (!canPlay) {
                            ProService().showPaywall(context);
                            return;
                          }
                          game.addCurrentUser();
                          Navigator.pushNamed(context, Routes.HomeRoute);
                        })
                    ],
                  ),
                ),
              ],
            )
          )
        );
      }
    );
  }
}
