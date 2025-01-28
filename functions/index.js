/**
 * Trigger cloud function:
 * https://console.cloud.google.com/cloudscheduler?project=helsie-2863d&authuser=1&jobs-tablequery=%255B%257B%2522k%2522%253A%2522name%2522%252C%2522t%2522%253A10%252C%2522v%2522%253A%2522firebase-schedule-scheduledFunction-us-central1%2522%252C%2522s%2522%253Atrue%257D%255D
 */
const functions = require("firebase-functions");
const admin = require('firebase-admin');
const GameState = {
  running:  0,
  waiting:  1,
  ended:    2
};
const localizations = {
  en: {
    joined: (name) => `${name} just joined!`,
    start: (name) => `${name} just started the game. Rock on! 🤘`,
    trigger: {
      title: "Let's go!",
      body: 'Showtime. Stop reading, start tapping - every millisecond matters. Just tap me.'
    }
  },
  de: {
    joined: (name) => `${name} ist mit am Start!`,
    start: (name) => `${name} hat so eben das Spiel gestartet. Ab jetzt gilt's! 🤘`,
    trigger: {
      title: "Abfahrt jetzt!",
      body: 'Wenn du abliefern willst, dann hör auf zu lesen und tipp mich. Dalli dalli.'
    }
  }
};

admin.initializeApp();

// runs at every minute
exports.scheduledFunction = functions.region('europe-west1').pubsub.schedule('* * * * *')
  .timeZone('Europe/Vienna')
  .onRun(async (context) => {
    const activeGames = await admin.firestore().collection('games')
                                .where('state', '==', GameState.running).get();

    activeGames.forEach(async (doc) => {
      let game = doc.data();
      let gameId = doc.id;
      let locale = game.locale || 'en';
      if(!Object.keys(localizations).includes(locale)) { locale = 'en'; }
      // count up minutes, scheduled functions runs every minute
      let data = {
        minute: (game.minute || 0) + 1
      };

      // SEND GAME NOTIFICATION if triggerMinute is reached
      if(data.minute >= game.triggerMinute && !game.notificationSentAt) {
        const payload = {
          notification: localizations[locale].trigger,
          data: { type: 'gameEnd', gameId: gameId }
        };
        data.notificationSentAt = new Date();
        await admin.messaging().sendToTopic(gameId, payload);
      // NOBODY TAPPED
      } else if(data.minute >= game.interval && game.notificationSentAt) {
        data.state = GameState.ended;
      }
      return doc.ref.update(data);
    });

    return true;
});

exports.updateGame = functions.region('europe-west1').firestore
  .document('games/{gameId}')
  .onUpdate(async (change, context) => {
    const game = change.after.data();
    const prevGame = change.before.data();
    const locale = game.locale || 'en';
    if(!Object.keys(localizations).includes(locale)) { locale = 'en'; }

    // sets winner and GAME end state
    if(prevGame.state == game.state && (game.state == GameState.running || game.state == GameState.ended)) {
      const newUsersThatTapped = Object.values(game.users).filter(u => u.pushedAt && prevGame.users[u.id] && !prevGame.users[u.id].pushedAt).length;

      // need this in case 2 users tapped at the same time
      // & the firebase request of the winner was slower than the first user's request!
      if(!game.winnerId || newUsersThatTapped.length) {
        const winner = Object.values(game.users).filter(u => u.pushedAt).sort((a,b) => b.pushedAt < a.pushedAt ? 1 : -1)[0];

        return winner ? change.after.ref.update({
          state: GameState.ended,
          winnerId: winner.id
        }) : false;
      }
    }

    // notify users when game starts
    if(prevGame.state == GameState.waiting && game.state == GameState.running) {
      const payload = {
        notification: {
          body: localizations[locale].start(game.users[game.creatorId].name)
        },
        data: { type: 'gameStart', gameId: context.params.gameId }
      };
      await admin.messaging().sendToTopic(context.params.gameId, payload);

      return change.after.ref.update({
        minute: 0,
        triggerMinute: Math.floor(Math.random() * game.interval) + 1
      });
    }

    // notifies creator when someone joins the game
    if(game.state == GameState.waiting && Object.values(game.users).length > Object.values(prevGame.users).length) {
      const newUser = Object.values(game.users).filter(u => !prevGame.users[u.id])[0];

      if(newUser) {
        const payload = {
          notification: {
            body: localizations[locale].joined(newUser.name)
          }
        };
        return admin.messaging().sendToDevice(game.creatorToken, payload);
      }
    }

    return false;
  });
