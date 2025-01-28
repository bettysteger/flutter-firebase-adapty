import 'package:flutter/material.dart';
import 'package:somegame/components/components.dart';
import 'package:somegame/models/game.dart';
import 'package:somegame/models/user.dart';
import 'package:somegame/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParticipantWaitingLine extends StatelessWidget {
  final User _user;
  ParticipantWaitingLine(this._user);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 79,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _user.name,
                  style: Body1TextStyle.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Container(
              height: 1,
              decoration: BoxDecoration(
                color: LightGray,
              ))
        ],
      ),
    );
  }
}

class ParticipantFinishedLine extends StatelessWidget {
  final User _user;
  final Game _game;
  ParticipantFinishedLine(this._user, this._game);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    var position = positionInGame();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 79,
            child: Column(
              children: [
                Spacer(),
                Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _user.name,
                            style: Body1TextStyle.copyWith(
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            _subText(t, position),
                            style: Body2TextStyle.copyWith(color: DarkGray),
                          ),
                        ],
                      ),
                    ),
                    if (position <= 3 && null != _user.pushedAt)
                      Spacer(),
                    if (position <= 3 && null != _user.pushedAt)
                      _buildBadge(position),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
          Container(
              height: 1,
              decoration: BoxDecoration(
                color: LightGray,
              ))
        ],
      ),
    );
  }

  BadgeEmoji _buildBadge(int position) {
    String emoji = "";
    switch (position) {
      case 1:
        emoji = '🥇';
        break;
      case 2:
        emoji = '🥈';
        break;
      case 3:
        emoji = '🥉';
        break;
      default:
        emoji = '💩';
        break;
    }
    return BadgeEmoji(emoji);
  }

  String _subText(t, position) {
    String res = '';
    if (_user.pushedAt == null) {
      res = t.missed;
    } else {
      int secs = _game.pushDifferenceInSecs(_user) ?? 0;
      int? millisecs = _game.pushDifferenceInMillisecs(_user);
      if(secs != 0) {
        res = t.secs(secs) + ' ';
      }
      if(millisecs != null && (secs < 2 || position <= 3)) {
        res += t.millisecs(millisecs);
      }
    }
    return res;
  }

  int positionInGame() {
    var ordered = _game.orderUsersByPushedAt();
    return ordered.indexWhere((user) => user.id == _user.id) + 1;
  }
}
