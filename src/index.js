import './main.css';
import './spacing.css';

import { Elm } from './Main.elm';
import * as firebase from 'firebase/app';
import 'firebase/auth';
import 'firebase/firestore';

import * as serviceWorker from './serviceWorker';

// Just checking envs are defined - Debug statement
console.log(process.env.ELM_APP_API_KEY !== undefined);

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

//  Observer on user info
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

    // Set up listened on new trainings
    db.collection(`users/${user.uid}/trainings`).onSnapshot(docs => {
      console.log('Received new snapshot');
      const trainings = [];
      console.log('docs', docs);

      docs.forEach(doc => {
        console.log('doc.data()', doc.data());
        const content = doc.data().content;
        if (content) {
          trainings.push(content);
        }
      });

      app.ports.receiveTrainings.send({
        trainings: trainings
      });
    });
  }
});

app.ports.saveTraining.subscribe(data => {
  const pretty = JSON.stringify(data.content, undefined, 2);
  console.log(`Saving training to database : ${pretty}`);

  db.collection(`users/${data.uid}/trainings`).doc(String(data.content.id))
    .set({
      content: data.content
    })
    .catch(error => {
      console.error(error);
    });
});

// app.ports.removeTraining.subscribe(data => {
//   const pretty = JSON.stringify(data.content, undefined, 2);
//   console.log(`Removing training from database : ${pretty}`);

//   db.collection(`users/${data.uid}/trainings`).doc(data.content.id)
//     .delete()
//     .catch(error => {
//       console.error(error);
//     });
// });

function getTodayString() {
  return (new Date()).toJSON().slice(0, 10).split('-').reverse().join('.');
}

app.ports.ask.subscribe(what => {
  if (what === 'today') {
    var today = getTodayString();
    app.ports.receive.send({today: today});
  }
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
