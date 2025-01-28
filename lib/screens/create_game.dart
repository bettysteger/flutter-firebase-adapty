import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:logging/logging.dart';
import 'package:somegame/theme.dart';
import 'package:somegame/components/button_text.dart';
import 'package:somegame/components/components.dart';
import 'package:somegame/models/game.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final Logger _log = Logger('create_game');

class CreateGame extends StatefulWidget {
  @override
  SliderOnLight createState() => SliderOnLight();
}

class SliderOnLight extends State<CreateGame> {
  Game game = Game(id: '')..setInterval(1);

  @override
  Widget build(BuildContext context) {
    _log.fine({'msg': 'build'});
    var t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              SpacingXL,
              SpacingHuge,
              SpacingXL,
              SpacingXL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    style: Headline2TextStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: t.create_timeframe_setting1,
                        style:
                            Headline2TextStyle.copyWith(fontWeight: FontWeight.w900),
                      ),
                      TextSpan(
                        text: t.create_timeframe_setting2,
                        style: Headline2TextStyle,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SpacingHuge),
                Text(
                  game.interval! < 60 ? t.create_slider_min(game.interval!) : t.create_slider_hours(game.interval! ~/ 60),
                  style: Headline1TextStyle.copyWith(
                      color: PrimaryColor, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: SpacingXS),
                Container(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: PrimaryColor,
                      inactiveTrackColor: LightGray,
                      trackHeight: 8.0,
                      thumbColor: PrimaryColor,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 16.0),
                      overlayColor: PrimaryColor.withAlpha(32),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 24),
                      activeTickMarkColor: Colors.transparent,
                      inactiveTickMarkColor: Colors.transparent,
                    ),
                    child: Slider(
                      min: Game.sliderMin,
                      max: Game.sliderMax,
                      divisions: Game.sliderDivision,
                      value: game.sliderInterval!,
                      onChanged: (value) {
                        setState(() {
                          game.setInterval(value);
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: SpacingXL),
                ButtonText(
                  t.button_create_game,
                  onTap: () async => {
                    game.locale = t.localeName,
                    await game.create(),
                    Navigator.pop(context)
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(padding: EdgeInsets.only(top: SpacingXL), child:
              NavigationBarIconRight(
                t.create_game_title,
                HeroIcons.xMark,
                TextColorDark,
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
