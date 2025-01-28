import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:somegame/components/participant_line.dart';
import 'package:somegame/models/game.dart';
import 'package:somegame/theme.dart';
import 'package:scoped_model/scoped_model.dart';

final Logger _log = Logger('member_list_finished');

class MemberList extends StatelessWidget {
  final Game game;
  MemberList({required this.game, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _log.fine({'msg': 'build', 'game': game.toString()});

    return StreamBuilder<Game>(
      stream: game.gameStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(backgroundColor: ExtralightGray, color: LightGray));
        }
        return ScopedModel<Game>(
          model: snapshot.data!,
          child: ScopedModelDescendant<Game>(builder: (context, child, model) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: model.users!.length,
              itemBuilder: (BuildContext context, int index) {
                return game.state == GameState.ended ? ParticipantFinishedLine(model.orderUsersByPushedAt()[index], model) : ParticipantWaitingLine(model.users![index]);
              },
            );
          }),
        );
      });
  }
}
