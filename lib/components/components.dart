import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:somegame/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Badge Emoji
class BadgeEmoji extends StatelessWidget {
  final String _badgelabel;
  BadgeEmoji(this._badgelabel);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      width: 44.0,
      decoration: BoxDecoration(
        gradient: PrimaryGradient,
        borderRadius: BorderRadius.all(
          Radius.circular(RadiusSmall),
        ),
        boxShadow: [ShadowSmallPrimary],
      ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _badgelabel,
              style: Headline3TextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

// Stat Counter
class StatCounter extends StatelessWidget {
  final Color _textcolor;
  final String _number;
  final String _label;
  StatCounter(this._textcolor, this._number, this._label);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _number.length > 5 ? 110.0 : 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _number,
            style: Headline3TextStyle.copyWith(color: _textcolor),
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

// Content on Light
class ContentOnLight extends StatelessWidget {
  final String _emoji;
  final String _headline;
  final String _headlinespan;
  final String _body;
  final String _counter1;
  final String _counter1label;
  final String _counter2;
  final String _counter2label;

  ContentOnLight(this._emoji, this._headline, this._headlinespan, this._body,
      this._counter1, this._counter1label, this._counter2, this._counter2label);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(_emoji != '')
            Text(
              _emoji,
              style: EmojiTextStyle,
            ),
          SizedBox(height: SpacingXS),
          RichText(
            text: TextSpan(
              style: Headline1TextStyle,
              children: <TextSpan>[
                TextSpan(
                  text: _headline,
                  style: Headline1TextStyle,
                ),
                TextSpan(
                  text: _headlinespan,
                  style:
                      Headline1TextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          SizedBox(height: SpacingS),
          Text(
            _body,
            style: Body1TextStyle,
          ),
          SizedBox(height: SpacingXXL),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StatCounter(TextColorDark, _counter1, _counter1label),
              StatCounter(TextColorDark, _counter2, _counter2label),
            ],
          ),
        ],
      ),
    );
  }
}

// Content on Dark
class ContentOnDark extends StatelessWidget {
  final String _emoji;
  final String _headline;
  final String _headlinespan;
  final String _body;
  final String? _counter1;
  final String? _counter1label;
  final String? _counter2;
  final String? _counter2label;

  ContentOnDark(this._emoji, this._headline, this._headlinespan, this._body,
      this._counter1, this._counter1label, this._counter2, this._counter2label);

  @override
  Widget build(BuildContext context) {
    final headlineTextStyle = _emoji == '👑' ? Headline2TextStyle : Headline1TextStyle;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _emoji,
            style: EmojiTextStyle,
          ),
          SizedBox(height: SpacingXS),
          RichText(
            text: TextSpan(
              style: headlineTextStyle,
              children: <TextSpan>[
                TextSpan(
                  text: _headline,
                  style: headlineTextStyle.copyWith(color: SecondaryColor),
                ),
                TextSpan(
                  text: _headlinespan,
                  style: headlineTextStyle.copyWith(
                      color: SecondaryColor, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          SizedBox(height: SpacingS),
          Text(
            _body,
            style: Body1TextStyle.copyWith(color: TextColorLight),
          ),
          SizedBox(height: SpacingXXL),
          if (_counter1 != null && _counter1label != null && _counter2 != null && _counter2label != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StatCounter(TextColorLight, _counter1!, _counter1label!),
                StatCounter(TextColorLight, _counter2!, _counter2label!),
              ],
            ),
        ],
      ),
    );
  }
}

// Navigation Bar Icon Left
class NavigationBarIconLeft extends StatelessWidget {
  final String _navigationbarlabel;
  final HeroIcons _iconleft;
  final Color _color;
  final GestureTapCallback onTap;
  NavigationBarIconLeft(this._navigationbarlabel, this._iconleft, this._color,
      {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(SpacingL, SpacingHuge, SpacingL, SpacingS),
      child: Row(
        children: [
          GestureDetector(
              onTap: () => {
                this.onTap()
              },
              child: HeroIcon(
                _iconleft,
                color: _color,
                size: 32.0,
              )),
          SizedBox(width: SpacingXS),
          Text(
            _navigationbarlabel.toUpperCase(),
            style: Subtitle1TextStyle.copyWith(color: _color),
          ),
        ],
      ),
    );
  }
}

// Navigation Bar Icon Right
class NavigationBarIconRight extends StatelessWidget {
  final String _navigationbarlabel;
  final HeroIcons _iconright;
  final Color _color;
  final GestureTapCallback onTap;
  NavigationBarIconRight(this._navigationbarlabel, this._iconright, this._color,
      {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(SpacingL, SpacingM, SpacingL, SpacingS),
      child: Row(
        children: [
          Text(
            _navigationbarlabel.toUpperCase(),
            style: Subtitle1TextStyle.copyWith(color: _color),
          ),
          Spacer(),
          GestureDetector(
              onTap: () => this.onTap(),
              child: HeroIcon(
                _iconright,
                color: _color,
                size: 24,
              )),
        ],
      ),
    );
  }
}

// Navigation Bar Blurred
class NavigationBarBlurred extends StatelessWidget {
  final String _navigationbarlabel;
  final HeroIcons _iconleft;
  final GestureTapCallback onTap;
  NavigationBarBlurred(this._navigationbarlabel, this._iconleft, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        padding: EdgeInsets.fromLTRB(SpacingL, SpacingHuge, SpacingL, SpacingS),
        color: Colors.white.withOpacity(0.9),
        child: BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: SpacingS, sigmaY: SpacingS),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () => {
                    this.onTap()
                  },
                  child: HeroIcon(
                    _iconleft,
                    color: TextColorDark,
                    size: 32.0,
                  )),
              SizedBox(width: SpacingXS),
              Text(
                _navigationbarlabel.toUpperCase(),
                style: Subtitle1TextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Input Field On Dark
class InputFieldOnDark extends StatelessWidget {
  final TextEditingController _textController;

  InputFieldOnDark(this._textController);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            controller: _textController,
            keyboardType: TextInputType.name,
            style: Body1TextStyle.copyWith(
                fontWeight: FontWeight.w700, color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context)!.registration_placeholder,
              hintStyle: Body1TextStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          Container(
            height: 2,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

/* Card Waiting Creator
class CardWaitingCreator extends StatelessWidget {
  final String _creator;
  final String _counter1;
  final String _counter2;

  CardWaitingCreator(this._creator, this._counter1, this._counter2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256.0,
      padding: EdgeInsets.all(SpacingM),
      decoration: BoxDecoration(
        gradient: SecondaryGradient,
        borderRadius: BorderRadius.all(
          Radius.circular(RadiusBig),
        ),
        boxShadow: [ShadowBigSecondary],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _creator,
                style: Body1TextStyle.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              TagOnLight('Warten'),
            ],
          ),
          Spacer(),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StatCounter(TextColorDark, _counter1, 'Spanne'),
                  Container(
                    padding: EdgeInsets.only(left: SpacingM),
                    child: StatCounter(TextColorDark, _counter2, 'am Drücker'),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: SpacingS),
                child: Row(
                  children: [
                    Expanded(
                      child: ButtonText('Battle starten.'),
                    ),
                    SizedBox(width: SpacingXS),
                    ButtonIcon(HeroIcons.userPlus),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Card Waiting
class CardWaiting extends StatelessWidget {
  final String _creator;
  final String _counter1;
  final String _counter2;

  CardWaiting(this._creator, this._counter1, this._counter2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256.0,
      padding: EdgeInsets.all(SpacingM),
      decoration: BoxDecoration(
        gradient: SecondaryGradient,
        borderRadius: BorderRadius.all(
          Radius.circular(RadiusBig),
        ),
        boxShadow: [ShadowBigSecondary],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _creator,
                style: Body1TextStyle.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              TagOnLight('Warten'),
            ],
          ),
          Spacer(),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StatCounter(TextColorDark, _counter1, 'Spanne'),
                  SizedBox(width: SpacingXS),
                  StatCounter(TextColorDark, _counter2, 'am Drücker'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Card Running
class CardRunning extends StatelessWidget {
  final String _creator;
  final String _counter1;
  final String _counter2;

  CardRunning(this._creator, this._counter1, this._counter2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256.0,
      padding: EdgeInsets.all(SpacingM),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(RadiusBig),
        ),
        boxShadow: [ShadowBigBlack],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _creator,
                style: Body1TextStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TextColorLight,
                ),
              ),
              Spacer(),
              TagOnDark('Läuft'),
            ],
          ),
          Spacer(),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StatCounter(TextColorLight, _counter1, 'Verbl. Zeit'),
                  SizedBox(width: SpacingXS),
                  StatCounter(TextColorLight, _counter2, 'am Drücker'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/
