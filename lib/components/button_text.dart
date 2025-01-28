import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:somegame/theme.dart';

// Button Text
class ButtonText extends StatefulWidget {
  final String _buttonlabel;
  final GestureTapCallback onTap;
  final String? style;
  final HeroIcons? icon;
  ButtonText(this._buttonlabel, {required this.onTap, this.style, this.icon});

  @override
  _ButtonTextState createState() => _ButtonTextState();
}

class _ButtonTextState extends State<ButtonText> {
  bool selected = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      onTapDown: (details) {
        setState(() {
          selected = false;
        });
      },
      onTapUp: (details) {
        setState(() {
          selected = true;
        });
      },
      onTapCancel: () {
        setState(() {
          selected = true;
        });
      },
      child: AnimatedContainer(
        height: 64.0,
        padding: EdgeInsets.fromLTRB(SpacingM, 0, SpacingM, 0),
        duration: Duration(milliseconds: AnimationDurationXXS),
        curve: AnimationCurveStandard,
        decoration: _boxDecoration(),
        child: AnimatedOpacity(
          opacity: selected ? 1 : 0.8,
          duration: Duration(milliseconds: AnimationDurationXXS),
          curve: AnimationCurveStandard,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(widget.icon != null)
                HeroIcon(
                  widget.icon!,
                  color: _textColor(),
                  // semanticLabel: widget._buttonlabel
                ),
              Text(
                (widget.icon != null ? '   ' : '') + widget._buttonlabel.toUpperCase(),
                style: ButtonTextStyle.copyWith(color: _textColor()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    BoxDecoration boxdeco = BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(RadiusMedium),
      ),
    );

    switch (widget.style) {
      case "dark":
        return boxdeco.copyWith(
          color: Colors.black,
          boxShadow: selected ? [ShadowBigBlack] : [ShadowMediumBlack],
        );
      case "secondary":
        return boxdeco.copyWith(
          color: ExtralightGray,
          boxShadow: selected ? null : [ShadowMediumBlack],
        );
      case "outline-primary":
        return boxdeco.copyWith(
          border: Border.all(
            color: PrimaryColor.withOpacity(0.2),
            width: 2.0,
          ),
        );
      case "outline-secondary":
        return boxdeco.copyWith(
          border: Border.all(
            color: SecondaryColor.withOpacity(0.3),
            width: 2.0,
          ),
        );
      default:
        return boxdeco.copyWith(
          gradient: PrimaryGradient,
          boxShadow: selected ? [ShadowBigPrimary] : [ShadowMediumPrimary]
        );
    }
  }

  Color _textColor() {
    switch (widget.style) {
      case "dark":
        return Colors.white;
      case "secondary":
        return Colors.black;
      case "outline-primary":
        return PrimaryColor;
      case "outline-secondary":
        return SecondaryColor;
      default:
        return TextColorLight;
    }
  }
}
