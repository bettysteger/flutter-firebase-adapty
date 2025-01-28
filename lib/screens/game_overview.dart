import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:somegame/components/button_text.dart';
import 'package:somegame/services/pro.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:somegame/theme.dart';
import 'package:somegame/components/button_icon.dart';
import 'package:somegame/components/card_game.dart';
import 'package:somegame/routes.dart';
import 'package:somegame/models/game.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameOverview extends StatefulWidget {
  final List<GameState> statusFilter;
  GameOverview({ Key? key, required this.statusFilter }) : super(key: key);

  @override
  State<GameOverview> createState() => _GameOverviewState();
}

class _GameOverviewState extends State<GameOverview> {
  bool _hasGames = false;

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    bool onTrophies = widget.statusFilter.contains(GameState.ended);
    String title = onTrophies ? t.trophies_title : t.games_title;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(
            SpacingM,
            SpacingHuge,
            SpacingM,
            SpacingXL,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: SpacingXL),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title.split(' ')[0],
                            style: Headline2TextStyle,
                          ),
                          Text(
                            title.split(' ')[1],
                            style: Headline2TextStyle.copyWith(
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    if(_hasGames && !onTrophies)
                      ButtonIcon(HeroIcons.plus, onTap: () async {
                        // add paywall check here, if more than 1 game is running at the same time, we need to check if user is pro
                        bool canPlay = await ProService().canPlay();
                        if (!canPlay) {
                          ProService().showPaywall(context);
                          return;
                        }
                        Navigator.pushNamed(context, Routes.CreateGameRoute);
                      }, style: 'outline-primary')
                  ],
                ),
              ),
              _buildListView(t)
            ],
          ),
        ),
      ),
    );
  }

  _buildListView(t) {
    return StreamBuilder<List<Game>>(
      stream: Game.games,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(backgroundColor: ExtralightGray, color: LightGray));
        }

        final games = snapshot.data?.where((game) => widget.statusFilter.contains(game.state)).toList();
        final bool stateChange = games!.isNotEmpty && !_hasGames;
        _hasGames = games.isNotEmpty;

        if(stateChange) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            setState(() {});
          });
        }
        bool onTrophies = widget.statusFilter.contains(GameState.ended);
        List<String> emptyStatesEmojis = onTrophies ? ['', '', ' 🏆 ', ''] : ['', '', ' 😴 ', ''];
        String emptyTitle = onTrophies ? t.trophies_title_empty : t.games_title_empty;
        String emptyBody = onTrophies ? t.trophies_body_empty : t.games_body_empty;

        return _hasGames ? ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: games.length,
          itemBuilder: (context, index) => _buildCardGame(games[index]),
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(color: Colors.transparent),
        ) : Container(
          padding: EdgeInsets.only(top: SpacingXL, left: SpacingL, right: SpacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(emptyStatesEmojis[0], style: TextStyle(fontSize: 50, height: 0.1)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(emptyStatesEmojis[1], style: TextStyle(fontSize: 50)),
                  Text(emptyStatesEmojis[2], style: TextStyle(fontSize: 83)),
                  Text(emptyStatesEmojis[3], style: TextStyle(fontSize: 50)),
                ],
              ),
              Text(emptyTitle, style: Headline3TextStyle.copyWith(color: MediumGray), textAlign: TextAlign.center),
              SizedBox(height: SpacingXS),
              Text(emptyBody, style: Body1TextStyle.copyWith(color: MediumGray), textAlign: TextAlign.center),
              SizedBox(height: SpacingXL),
              ButtonText(t.button_create_game, onTap: () async {
                if (onTrophies) {
                  bool canPlay = await ProService().canPlay();
                  if (!canPlay) {
                    ProService().showPaywall(context);
                    return;
                  }
                }
                Navigator.pushNamed(context, Routes.CreateGameRoute);
              }),
            ],
          )
        );
    });
  }

  _buildCardGame(Game game) {
    return ScopedModel<Game>(model: game, child: CardGame());
  }
}
