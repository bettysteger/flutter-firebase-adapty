import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:somegame/components/components.dart';
import 'package:somegame/theme.dart';

class ModalSheet {

  static Future<T?> show<T>(BuildContext context, Widget child, String title, bool hasPrimaryBg) {
    double height = MediaQuery.of(context).size.height * .9;
    final borderRadius = BorderRadius.vertical(top: Radius.circular(10.0));

    return showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(minHeight: height, maxHeight: height),
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: hasPrimaryBg ? BoxDecoration(gradient: PrimaryGradient, borderRadius: borderRadius) : null,
        child: Column(
          children: [
            NavigationBarIconRight(
              title,
              HeroIcons.xMark,
              hasPrimaryBg ? TextColorLight : TextColorDark,
              onTap: () => Navigator.pop(context)),
            Expanded(child: SingleChildScrollView(
              child: child,
              padding: EdgeInsets.fromLTRB(SpacingXL, 0, SpacingXL, SpacingXL),
              physics: BouncingScrollPhysics(),
            )),
          ],
        )
      ),
      shape: RoundedRectangleBorder(borderRadius: borderRadius)
    );
  }

}