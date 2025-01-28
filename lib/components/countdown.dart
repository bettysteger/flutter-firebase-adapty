import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:somegame/models/game.dart';

final Logger _log = Logger('countdown');

class Countdown extends StatefulWidget {
  final Game game;
  final Widget Function(BuildContext, String) build;
  Countdown(this.game, this.build);

  @override
  CountdownState createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  Timer? _timer;
  String _countdown = "0";

  @override
  void initState() {
    _log.fine({'msg': 'initState'});

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (widget.game.remainingTime().inSeconds <= 0) {
          _timer?.cancel();
          _countdown = "0";
          widget.game.update({'state': GameState.ended.index});
        } else {
          _countdown = _calcRemainingTimeAsString(widget.game);
          // _log.fine({'msg': _countdown});
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _log.fine({'msg': 'dispose'});
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _countdown);

  String _calcRemainingTimeAsString(Game game) {
    var remaining = game.remainingTime();
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(remaining.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(remaining.inSeconds.remainder(60));
    if (remaining.inHours > 0) {
      return "${twoDigits(remaining.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

}
