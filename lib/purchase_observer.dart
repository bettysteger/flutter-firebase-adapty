// from example https://github.com/adaptyteam/AdaptySDK-Flutter/blob/master/example/lib/purchase_observer.dart
// extended with adaptyProfile and removed a few functions
import 'dart:async' show Future;
import 'package:adapty_flutter/adapty_flutter.dart';

class PurchasesObserver {
  void Function(AdaptyError)? onAdaptyErrorOccurred;
  void Function(Object)? onUnknownErrorOccurred;

  final adapty = Adapty();

  AdaptyProfile? adaptyProfile;

  static final PurchasesObserver _instance = PurchasesObserver._internal();

  factory PurchasesObserver() {
    return _instance;
  }

  PurchasesObserver._internal();

  Future<void> initialize() async {
    try {
      // adapty.setLogLevel(AdaptyLogLevel.verbose);
      adapty.activate();
      adaptyProfile = await callGetProfile(); // <---- changed this line
    } catch (e) {
      print('#Example# activate error $e');
    }
  }

  void setProfile(AdaptyProfile profile) {
    adaptyProfile = profile;
  }

  Future<AdaptyProfile?> callGetProfile() async {
    try {
      final result = await adapty.getProfile();
      return result;
    } on AdaptyError catch (adaptyError) {
      onAdaptyErrorOccurred?.call(adaptyError);
    } catch (e) {
      onUnknownErrorOccurred?.call(e);
    }

    return null;
  }

  Future<AdaptyPaywall?> callGetPaywall(
    String paywallId,
    AdaptyPaywallFetchPolicy fetchPolicy,
    String? locale,
  ) async {
    try {
      final result = await adapty.getPaywall(
        placementId: paywallId,
        locale: locale,
        fetchPolicy: fetchPolicy,
        loadTimeout: const Duration(seconds: 5),
      );
      return result;
    } on AdaptyError catch (adaptyError) {
      onAdaptyErrorOccurred?.call(adaptyError);
    } catch (e) {
      onUnknownErrorOccurred?.call(e);
    }

    return null;
  }

  Future<List<AdaptyPaywallProduct>?> callGetPaywallProducts(AdaptyPaywall paywall) async {
    try {
      final result = await adapty.getPaywallProducts(paywall: paywall);
      return result;
    } on AdaptyError catch (adaptyError) {
      onAdaptyErrorOccurred?.call(adaptyError);
    } catch (e) {
      onUnknownErrorOccurred?.call(e);
    }

    return null;
  }

  Future<AdaptyProfile?> callMakePurchase(AdaptyPaywallProduct product) async {
    try {
      final result = await adapty.makePurchase(product: product);
      if (result != null) setProfile(result); // <---- changed this line
      return result;
    } on AdaptyError catch (adaptyError) {
      onAdaptyErrorOccurred?.call(adaptyError);
    } catch (e) {
      onUnknownErrorOccurred?.call(e);
    }

    return null;
  }

  Future<AdaptyProfile?> callRestorePurchases() async {
    try {
      final result = await adapty.restorePurchases();
      setProfile(result); // <---- changed this line
      return result;
    } on AdaptyError catch (adaptyError) {
      onAdaptyErrorOccurred?.call(adaptyError);
    } catch (e) {
      onUnknownErrorOccurred?.call(e);
    }

    return null;
  }

  // Future<void> callLogShowPaywall(AdaptyPaywall paywall) async {
  //   try {
  //     await adapty.logShowPaywall(paywall: paywall);
  //   } on AdaptyError catch (adaptyError) {
  //     onAdaptyErrorOccurred?.call(adaptyError);
  //   } catch (e) {
  //     onUnknownErrorOccurred?.call(e);
  //   }
  // }

  // Future<void> callLogShowOnboarding(String? name, String? screenName, int screenOrder) async {
  //   try {
  //     await adapty.logShowOnboarding(name: name, screenName: screenName, screenOrder: screenOrder);
  //   } on AdaptyError catch (adaptyError) {
  //     onAdaptyErrorOccurred?.call(adaptyError);
  //   } catch (e) {
  //     onUnknownErrorOccurred?.call(e);
  //   }
  // }

  // Future<void> callLogout() async {
  //   try {
  //     await adapty.logout();
  //   } on AdaptyError catch (adaptyError) {
  //     onAdaptyErrorOccurred?.call(adaptyError);
  //   } catch (e) {
  //     onUnknownErrorOccurred?.call(e);
  //   }
  // }
}