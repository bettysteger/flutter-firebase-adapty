import 'package:somegame/components/modal_sheet.dart';
import 'package:somegame/models/game.dart';
import 'package:somegame/purchase_observer.dart';
import 'package:somegame/screens/paywall.dart';

class ProService {

  final observer = PurchasesObserver();
  final activeGameLimit = 1;

  bool get isPro => observer.adaptyProfile?.accessLevels['premium']?.isActive ?? false;

  // user can play if he is pro or has less than activeGameLimit games
  Future<bool> canPlay() async {
    if (isPro) return true;
    int count = await Game.activeGamesCount();
    return count < activeGameLimit;
  }

  Future showPaywall(context) {
    return ModalSheet.show(context, Paywall(), '', true);
  }
}