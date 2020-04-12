import './main.css';
import './spacing.css';

import { Elm } from './Main.elm';
import * as firebase from "firebase/app";
import "firebase/auth";
import "firebase/firestore";

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
  console.log('login');
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
      console.error(error);
    });
});

app.ports.signOut.subscribe(() => {
  console.log('logout');
  firebase.auth().signOut();
});

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
