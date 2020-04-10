import './main.css';
import './spacing.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

const app = Elm.Main.init({
  node: document.getElementById('root')
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
