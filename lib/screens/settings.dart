import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:somegame/components/button_text.dart';
import 'package:somegame/components/modal_sheet.dart';
import 'package:somegame/purchase_observer.dart';
import 'package:somegame/screens/imprint.dart';
import 'package:somegame/screens/paywall.dart';
import 'package:somegame/services/auth.dart';
import 'package:somegame/services/pro.dart';
import 'package:somegame/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {

  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    // check if Somegame Pro is active
    PurchasesObserver().callGetProfile();
    super.initState();
  }

  Future<void> _openNameDialog(BuildContext context) async {
    var t = AppLocalizations.of(context)!;
    final currentUser = AuthService().currentUser!;
    _textFieldController.text = currentUser.name;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.registration_title2),
          content: TextField(
            controller: _textFieldController,
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                String newName = _textFieldController.text.trim();
                if (newName != '' && currentUser.name != newName) {
                  currentUser.name = newName;
                  await AuthService().signInAnonymously(newName);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            SpacingXL,
            SpacingHuge,
            SpacingXL,
            SpacingXL,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.settings_headline1, style: Headline2TextStyle),
              Text(
                t.settings_headline2,
                style: Headline2TextStyle.copyWith(fontWeight: FontWeight.w900),
              ),
              SizedBox(height: SpacingXL),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(RadiusBig)),
                  gradient: ProService().isPro ? PrimaryGradient : null,
                  border: ProService().isPro ? null : Border.all(color: PrimaryShadowColor, width: 2),
                ),
                padding: EdgeInsets.all(SpacingXS),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('👑', style: EmojiTextStyle, textAlign: TextAlign.center),
                    SizedBox(height: SpacingXS),
                    Text(
                      t.subscription_title,
                      style: Headline3TextStyle.copyWith(color: ProService().isPro ? TextColorLight : PrimaryColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SpacingXS),
                    // SizedBox(width: 200, child:
                    Text(
                      ProService().isPro ? t.subscription_card_true : t.subscription_card_false,
                      style: Body2TextStyle.copyWith(color: ProService().isPro ? TextColorLight : TextColorDark, fontWeight: FontWeight.w600),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    // ),
                    SizedBox(height: SpacingM),
                    if (!ProService().isPro)
                      ButtonText(t.subscription_card_btn, onTap: () => ModalSheet.show(context, Paywall(), '', true)),
                  ],
                ),
              ),
              SizedBox(height: SpacingXL),
              ListTile(
                leading: Text('✍️', style: TextStyle(fontSize: 24)),
                title: Text(t.settings_change_name_title),
                subtitle: Text(t.settings_change_name_body),
                trailing: HeroIcon(HeroIcons.chevronRight, size: 9),
                contentPadding: EdgeInsets.zero,
                onTap: () => _openNameDialog(context),
              ),
              // Divider line
              Container(
                margin: EdgeInsets.symmetric(vertical: SpacingXS),
                height: 1,
                color: LightGray,
              ),
              ListTile(
                leading: Text('📄', style: TextStyle(fontSize: 24)),
                title: Text(t.settings_imprint_title),
                subtitle: Text(t.settings_imprint_body),
                trailing: HeroIcon(HeroIcons.chevronRight, size: 9),
                contentPadding: EdgeInsets.zero,
                onTap: () => ModalSheet.show(context, Imprint(), t.settings_imprint_title, false),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
