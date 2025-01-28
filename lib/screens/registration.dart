import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:somegame/services/auth.dart';
import 'package:somegame/theme.dart';
import 'package:somegame/components/components.dart';
import 'package:somegame/components/button_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final Logger _log = Logger('home');

class Registration extends StatelessWidget {
  final _controller = TextEditingController();
  final _auth = AuthService();

  Future<void> _register(String name) async {
    _log.fine({'msg': 'register', 'name': name});
    return _auth.signInAnonymously(name);
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        gradient: PrimaryGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          reverse: true,
          padding: EdgeInsets.fromLTRB(
            SpacingXL,
            SpacingHuge,
            SpacingXL,
            SpacingXL,
          ),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 240,
                  width: 240,
                  child: Image.asset(
                    "assets/images/logo-transparent.png",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: SpacingM),
                RichText(
                  text: TextSpan(
                    style: Headline2TextStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: t.registration_title1,
                        style:
                            Headline2TextStyle.copyWith(color: TextColorLight),
                      ),
                      TextSpan(
                        text: t.registration_title2,
                        style: Headline2TextStyle.copyWith(
                            color: TextColorLight, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SpacingS),
                InputFieldOnDark(_controller),
                SizedBox(height: SpacingS),
                Container(
                  padding: EdgeInsets.only(top: SpacingS),
                  child: Row(
                    children: [
                      Expanded(
                        child: ButtonText(
                          t.button_next,
                          onTap: () {
                            if (_controller.text.isNotEmpty) {
                              _register(_controller.text.trim());
                              _controller.text = ''; // prevent re-submit
                            }
                          },
                          style: "dark"
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
