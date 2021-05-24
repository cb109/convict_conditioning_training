import './main.css';
import './spacing.css';

import { Elm } from './Main.elm';
import * as firebase from 'firebase/app';
import 'firebase/auth';
import 'firebase/firestore';

import * as serviceWorker from './serviceWorker';

// Just checking envs are defined - Debug statement
console.log(process.env.ELM_APP_API_KEY !== undefined);

let pageLimit = 24;

const firebaseConfig = {
  apiKey: process.env.ELM_APP_API_KEY,
  authDomain: process.env.ELM_APP_AUTH_DOMAIN,
  databaseURL: process.env.ELM_APP_DATABASE_URL,
  projectId: process.env.ELM_APP_PROJECT_ID,
  storageBucket: process.env.ELM_APP_STORAGE_BUCKET,
  messagingSenderId: process.env.ELM_APP_MESSAGING_SENDER_ID,
  appId: process.env.ELM_APP_APP_ID
};

firebase.initializeApp(firebaseConfig);

const provider = new firebase.auth.GoogleAuthProvider();
const db = firebase.firestore();

const app = Elm.Main.init({
  node: document.getElementById('root')
});

function prettifyJson(data) {
  return JSON.stringify(data, undefined, 2);
}

function getTrainingsSnapshotForUser(userId) {
  console.log('Fetching trainings snapshot...');
  return db.collection(`users/${userId}/trainings`).get();
}

function forwardTrainingDocumentsToElm(docs) {
  const trainings = [];

  docs.forEach(doc => {
    const content = doc.data().content;
    if (content) {

      // TODO: Remove this once existing trainings have the new .locked <bool> field.
      if (content.locked === undefined) {
        content.locked = false;
      }

      trainings.push(content);
    }
  });

  app.ports.receiveTrainings.send({
    trainings: trainings
  });
}

app.ports.signIn.subscribe(() => {
  console.log('signIn');
  firebase
    .auth()
    .signInWithPopup(provider)
    .then(result => {
      result.user.getIdToken().then(idToken => {
        app.ports.signInInfo.send({
          token: idToken,
          email: result.user.email,
          uid: result.user.uid
        });
      });
    })
    .catch(error => {
      alert('Error when logging in');
      console.error(error);
    });
});

app.ports.signOut.subscribe(() => {
  console.log('signOut');
  firebase.auth().signOut();
});

app.ports.unsetPageLimit.subscribe(uid => {
  console.log('unsetPageLimit');
  pageLimit = null;
  getTrainingsSnapshotForUser(uid)
    .then(snapshot => {
      // downloadTrainingDocumentsAsJson(snapshot.docs);
      forwardTrainingDocumentsToElm(snapshot.docs);
    });
});

firebase.auth().onAuthStateChanged(user => {
  console.log('onAuthStateChanged');
  if (user) {
    user
      .getIdToken()
      .then(idToken => {
        app.ports.signInInfo.send({
          token: idToken,
          email: user.email,
          uid: user.uid
        });
      })
      .catch(error => {
        alert('Error when retrieving cached user');
        console.error(error);
      });

    // Set up listener on new trainings
    db.collection(`users/${user.uid}/trainings`)
      .orderBy('content.date', 'desc')
      .limit(pageLimit)
      .onSnapshot(docs => {
        console.log('Received new snapshot');
        forwardTrainingDocumentsToElm(docs);
      });
  }
});

app.ports.saveTraining.subscribe(data => {
  console.log(`Saving training to database: ${prettifyJson(data.content)}`);

  db.collection(`users/${data.uid}/trainings`).doc(String(data.content.id))
    .set({
      content: data.content
    })
    .then(() => {
      console.log('Training has been saved');
    })
    .catch(error => {
      alert('Error when saving Training');
      console.error(error);
    });
});

app.ports.removeTraining.subscribe(data => {
  console.log(`Removing training from database: ${prettifyJson(data.content)}`);

  const confirmed = confirm('Do you really want to remove this training?');
  if (!confirmed) {
    // Ensure the change in the model is reversed.
    getTrainingsSnapshotForUser(data.uid)
      .then(snapshot => {
        forwardTrainingDocumentsToElm(snapshot.docs);
      });
    return;
  }

  db.collection(`users/${data.uid}/trainings`).doc(String(data.content.id))
    .delete()
    .then(() => {
      console.log('Training has been removed');
    })
    .catch(error => {
      alert('Error when removing Training');
      console.error(error);
    });
});

/** Return a datestring like '2019-12-01' */
function getTodayString() {
  return (new Date()).toJSON().slice(0, 10);
}

function downloadTrainingDocumentsAsJson(docs) {
  const allTrainings = [];
  docs.forEach(doc => {
    const content = doc.data().content;
    if (content) {
      allTrainings.push(content);
    }
  });
  // Trigger download.
  var json = JSON.stringify(allTrainings);
  var blob = new Blob([json], {type: 'application/json'});
  var url  = URL.createObjectURL(blob);
  window.location = url;
}

app.ports.ask.subscribe(what => {
  if (what === 'today') {
    var today = getTodayString();
    app.ports.receive.send({ today: today });
  }
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.register();
