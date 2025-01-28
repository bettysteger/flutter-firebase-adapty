import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:somegame/theme.dart';

// Button Icon
class ButtonIcon extends StatefulWidget {
  final HeroIcons _icon;
  final GestureTapCallback onTap;
  final String? style;
  ButtonIcon(this._icon, {required this.onTap, this.style});

  @override
  _ButtonIconState createState() => _ButtonIconState();
}

class _ButtonIconState extends State<ButtonIcon> {
  bool selected = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          selected = false;
        });
        widget.onTap();
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
        width: 64.0,
        duration: Duration(milliseconds: AnimationDurationXXS),
        curve: AnimationCurveStandard,
        decoration: BoxDecoration(
          gradient: widget.style == null ? PrimaryGradient : null,
          borderRadius: BorderRadius.all(
            Radius.circular(RadiusMedium),
          ),
          boxShadow: widget.style == null ? (selected ? [ShadowBigPrimary] : [ShadowMediumPrimary]) : null,
          border: widget.style == 'outline-primary' ? Border.all(
            color: PrimaryColor.withOpacity(0.2),
            width: 2.0,
          ) : null,
        ),
        child: AnimatedOpacity(
          opacity: selected ? 1 : 0.8,
          duration: Duration(milliseconds: AnimationDurationXXS),
          curve: AnimationCurveStandard,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeroIcon(
                widget._icon,
                color: widget.style == 'outline-primary' ? PrimaryColor : TextColorLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
