import 'dart:math';

import 'package:provider/provider.dart';
import 'package:somegame/models/game.dart';
import 'package:somegame/models/user.dart';
import 'package:somegame/screens/invitation.dart';
import 'package:somegame/screens/registration.dart';
import 'package:somegame/screens/game_overview.dart';
import 'package:somegame/screens/settings.dart';
import 'package:somegame/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatelessWidget {
  final String? gameId;
  Home({this.gameId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    final user = Provider.of<User?>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Registration();
    } else if (this.gameId != null) {
      return Invitation(gameId: gameId!);
    } else {
      var paddingBottomOfSafeArea = MediaQuery.of(context).padding.bottom;
      paddingBottomOfSafeArea = max(SpacingXS, paddingBottomOfSafeArea / 1.2);

      return DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: TabBar(
            labelColor: PrimaryColor,
            labelStyle: TabBarTextStyle,
            unselectedLabelColor: NavGray,
            indicator: CircleTabIndicator(color: PrimaryColor, radius: 2),
            padding: EdgeInsets.only(bottom: paddingBottomOfSafeArea),
            tabs: [
              Tab(
                text: t.tabbar_tab1,
                height: 56,
                icon: Text('⚡️', style: TextStyle(fontSize: 24)),
                iconMargin: EdgeInsets.zero,
              ),
              Tab(
                text: t.tabbar_tab2,
                height: 56,
                icon: Text('🏆', style: TextStyle(fontSize: 24)),
                iconMargin: EdgeInsets.zero,
              ),
              Tab(
                text: t.tabbar_tab3,
                height: 56,
                icon: Text('👤', style: TextStyle(fontSize: 24)),
                iconMargin: EdgeInsets.zero,
              ),
            ],
          ),
          body: TabBarView(
            children: [
              GameOverview(statusFilter: [GameState.running, GameState.waiting]),
              GameOverview(statusFilter: [GameState.ended]),
              Settings(),
            ],
          ),
        ),
      );
    }

  }
}


class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({required Color color, required double radius}) : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset = offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
