import 'package:somegame/push_notifications_manager.dart';
import 'package:somegame/services/auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:somegame/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('games');

enum GameState { running, waiting, ended }

class Game extends Model {
  final String id;
  String locale = 'en';
  GameState? state;
  int? interval; // in minutes
  String? creatorId;
  String? winnerId;
  bool isCreator = false;
  User? creator;
  List<User>? users;
  DateTime? createdAt;
  DateTime? startsAt;
  DateTime? notificationSentAt;

  // ui
  double? sliderInterval;
  static const double sliderMin = 1;
  static const double sliderMax = 10;
  static const int sliderDivision = 9;

  Game(
      {required this.id,
      this.interval,
      this.state,
      this.createdAt,
      this.startsAt,
      this.isCreator = false});

  // create game obj based on firebase game
  // Game _gameFromFirebase(game) {
  //   return game != null ? Game(id: game.id, interval: game.interval) : null;
  // }

  static Stream<List<Game>> get games {
    final currentUser = AuthService().currentUser;

    return _firestore.collection('games').where('users.${currentUser!.id}', isNull: false)
        .withConverter<Game>(
          fromFirestore: (snapshot, _) => Game.fromJson(snapshot.data()!, snapshot.id, currentUser.id),
          toFirestore: (model, _) => model.toJson(),
        ).snapshots().map((snapshot) {
          var list = snapshot.docs.map((doc) => doc.data()).toList();
          list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          return list;
        });
  }

  static Future<int> activeGamesCount() async {
    final currentUser = AuthService().currentUser;
    const source = Source.serverAndCache;

    // 2 where queries would need an index, but i can't set index for dynamic field (users.${currentUser.id})
    final response = await _firestore.collection('games').where('users.${currentUser!.id}', isNull: false)
                                    //  .where('state', isEqualTo: GameState.running.index)
                                     .get(const GetOptions(source: source));
    return response.docs.where((e) => e.data()['state'] != GameState.ended.index).length;

    // AggregateQuery query = _firestore.collection('games').where('users.${currentUser!.id}', isNull: false)
    //                                  .where('state', isEqualTo: GameState.running.index).count();
    // final response = await query.get();
    // return response.count ?? 0;
  }

  Future<DocumentReference> create() async {
    final currentUser = AuthService().currentUser;
    final pushToken = await PushNotificationsManager.getInstance().getToken();
    final users = {};
    users[currentUser!.id] = currentUser.toJson();

    return _mainCollection.add({
      "creatorId": currentUser.id,
      "creatorToken": pushToken,
      "createdAt": DateTime.now(),
      "locale": locale,
      "interval": interval,
      "state": GameState.waiting.index,
      "users": users,
    });
  }

  Stream<Game> get gameStream {
    return _mainCollection.doc(id).snapshots().map((snapshot) => Game.fromJson(snapshot.data()!, snapshot.id, AuthService().currentUser!.id));
  }

  Future<Game?> get() async {
    return _mainCollection.doc(id).get().then((doc) {
      if (doc.exists) {
        return Game.fromJson(doc.data()!, doc.id, AuthService().currentUser!.id);
      } else {
        return null;
      }
    });
  }

  Future<void> update(json) async {
    return _mainCollection.doc(id).update(json);
  }

  Game.fromJson(json, String id, String currentUserId)
      : id = id,
        state = GameState.values[json['state']],
        interval = json['interval'],
        createdAt = json['createdAt']?.toDate(),
        startsAt = json['startsAt']?.toDate(),
        notificationSentAt = json['notificationSentAt']?.toDate(),
        creatorId = json['creatorId'],
        winnerId = json['winnerId'],
        users = Game.buildUsers(json['users'], currentUserId),
        creator = User.fromJson(json['users'][json['creatorId']], json['creatorId']),
        isCreator = json['creatorId'] == currentUserId;

  Map<String, dynamic> toJson() {
    var res = Map<String, dynamic>();
    res['id'] = id;
    if (null != state) {
      res['state'] = state;
    }
    if (null != interval) {
      res['interval'] = interval;
    }
    if (null != startsAt) {
      res['startsAt'] = startsAt;
    }
    if (creatorId != null) {
      res['creatorId'] = creatorId;
    }
    if (users != null) {
      res['users'] = users;
    }

    return res;
  }

  int get usersCount {
    var count = 0;
    if (null != users) {
      count = users!.length;
    }
    return count;
  }

  static List<User> buildUsers(users, currentUserId) {
    List<User> res = [];
    if (null != users) {
      users.forEach((userId, user) {
        res.add(User.fromJson(user, userId));
      });
    }
    return res;
  }

  Future<void> addCurrentUser() async {
    await PushNotificationsManager.getInstance().subscribeToGame(Game(id: this.id));
    final u = AuthService().currentUser!;
    return _mainCollection.doc(this.id).update({'users.${u.id}': u.toJson()});
  }

  Future<void> updateUser(User u) {
    return _mainCollection.doc(this.id).update({'users.${u.id}': u.toJson()});
  }

  Future<void> deleteOrLeave() async {
    final currentUser = AuthService().currentUser;
    if (isCreator) {
      return _mainCollection.doc(id).delete();
    } else {
      return _mainCollection.doc(id).update({'users.${currentUser!.id}': FieldValue.delete()});
    }
  }

  List<User> orderUsersByPushedAt() {
    var sorted = List<User>.from(users!);
    sorted.sort((a, b) => a.pushedAt == null ? b.pushedAt == null ? 0 : 1 : b.pushedAt == null ? -1 : a.pushedAt!.compareTo(b.pushedAt!));
    return sorted;
  }

  int? pushDifferenceInSecs(User u) {
    if(u.pushedAt == null || notificationSentAt == null) { return null; }
    DateTime gameEndsAt = startsAt!.add(Duration(minutes: interval!));
    if(u.pushedAt!.isAfter(gameEndsAt)) { return null; }

    return u.pushedAt!.difference(notificationSentAt!).inSeconds;
  }

  int? pushDifferenceInMillisecs(User u) {
    int? secs = pushDifferenceInSecs(u);
    if(secs == null) { return null; }
    return u.pushedAt!.difference(notificationSentAt!).inMilliseconds - secs * 1000;
  }

  // value is between 1.0 and 10.0 (see sliderMin and sliderMax)
  void setInterval(double value) {
    sliderInterval = value;
    const intervals = [1, 5, 30, 45, 60, 60 * 2, 60 * 3, 60 * 6, 60 * 12, 60 * 24];
    interval = intervals[value.toInt() - 1];
  }

  String intervalAsString() {
    return interval! < 60 ? interval.toString() + 'm' : (interval! ~/ 60).toString() + 'h';
  }

  Duration remainingTime() {
    DateTime endTime = startsAt!.add(Duration(minutes: interval!));
    return endTime.difference(DateTime.now());
  }

  void share(t) {
    Share.share(
      'https://brand-io.app.link/join?id=' + id.toString(),
      subject: t.game_invite(creator!.name)
    );
  }
}
