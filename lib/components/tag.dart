import 'package:flutter/material.dart';
import 'package:somegame/theme.dart';

class Tag extends StatelessWidget {
  final Color _tagColor;
  final Color _tagTextColor;
  final String _tagLabel;
  Tag(this._tagColor, this._tagTextColor, this._tagLabel);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SpacingXS),
      decoration: BoxDecoration(
        color: _tagColor,
        borderRadius: BorderRadius.all(
          Radius.circular(RadiusMax),
        ),
      ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _tagLabel.toUpperCase(),
              style: Subtitle2TextStyle.copyWith(color: _tagTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
