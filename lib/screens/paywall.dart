import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:somegame/components/button_text.dart';
import 'package:somegame/components/components.dart';
import 'package:somegame/purchase_observer.dart';
import 'package:somegame/services/pro.dart';
import 'package:somegame/theme.dart';

class Paywall extends StatefulWidget {
  Paywall({Key? key}) : super(key: key);

  @override
  State<Paywall> createState() => PaywallState();
}

class PaywallState extends State<Paywall> {
  final purchasesObserver = PurchasesObserver();
  final String paywallId = 'settings';
  DemoPaywallFetchPolicy _adaptyPaywallFetchPolicy = DemoPaywallFetchPolicy.reloadRevalidatingCacheData;
  AdaptyPaywallProduct? product;

  @override
  void initState() {
    super.initState();

    purchasesObserver.callGetPaywall(paywallId, _adaptyPaywallFetchPolicy.adaptyPolicy(), null).then((paywall) {
      if (paywall != null) {
        purchasesObserver.callGetPaywallProducts(paywall).then((products) {
          if (products != null && products.isNotEmpty) {
            product = products[0];
          }
        });
      }
    });
  }

  Future<void> buy() async {
    if (product == null) return;

    await purchasesObserver.callMakePurchase(product!);

    if (ProService().isPro) { // close if buy was successful
      Navigator.pop(context);
    } else {
      // show error message
    }
  }

  void restore() {
    purchasesObserver.callRestorePurchases().then((profile) => {
      if (ProService().isPro) { // close if restore was successful
        Navigator.pop(context)
      } else {
        // show error message
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ContentOnDark(
          '👑',
          t.subscription_headline1 + '\n',
          t.subscription_headline2,
          t.subscription_body,
          null, null, null, null
        ),
        ButtonText(t.subscription_btn_restore_purchases, onTap: restore, style: "outline-secondary"),
        SizedBox(height: SpacingXS),
        ButtonText(t.subscription_btn, onTap: buy, style: "dark"),
      ],
    );
  }
}





enum DemoPaywallFetchPolicy {
  reloadRevalidatingCacheData,
  returnCacheDataElseLoad,
  returnCacheDataIfNotExpiredElseLoadMaxAge10sec,
  returnCacheDataIfNotExpiredElseLoadMaxAge30sec,
  returnCacheDataIfNotExpiredElseLoadMaxAge120sec,
}

extension DemoPaywallFetchPolicyExtension on DemoPaywallFetchPolicy {
  String title() {
    switch (this) {
      case DemoPaywallFetchPolicy.reloadRevalidatingCacheData:
        return "Reload Revalidating Cache Data";
      case DemoPaywallFetchPolicy.returnCacheDataElseLoad:
        return "Return Cache Data Else Load";
      case DemoPaywallFetchPolicy.returnCacheDataIfNotExpiredElseLoadMaxAge10sec:
        return "Cache Else Load (Max Age 10sec)";
      case DemoPaywallFetchPolicy.returnCacheDataIfNotExpiredElseLoadMaxAge30sec:
        return "Cache Else Load (Max Age 30sec)";
      case DemoPaywallFetchPolicy.returnCacheDataIfNotExpiredElseLoadMaxAge120sec:
        return "Cache Else Load (Max Age 120sec)";
    }
  }

  AdaptyPaywallFetchPolicy adaptyPolicy() {
    switch (this) {
      case DemoPaywallFetchPolicy.reloadRevalidatingCacheData:
        return AdaptyPaywallFetchPolicy.reloadRevalidatingCacheData;
      case DemoPaywallFetchPolicy.returnCacheDataElseLoad:
        return AdaptyPaywallFetchPolicy.returnCacheDataElseLoad;
      case DemoPaywallFetchPolicy.returnCacheDataIfNotExpiredElseLoadMaxAge10sec:
        return AdaptyPaywallFetchPolicy.returnCacheDataIfNotExpiredElseLoad(const Duration(seconds: 10));
      case DemoPaywallFetchPolicy.returnCacheDataIfNotExpiredElseLoadMaxAge30sec:
        return AdaptyPaywallFetchPolicy.returnCacheDataIfNotExpiredElseLoad(const Duration(seconds: 30));
      case DemoPaywallFetchPolicy.returnCacheDataIfNotExpiredElseLoadMaxAge120sec:
        return AdaptyPaywallFetchPolicy.returnCacheDataIfNotExpiredElseLoad(const Duration(seconds: 120));
    }
  }
}