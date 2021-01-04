# Convict Conditioning Training

This is a little progress tracker for the exercises listed in the [Convict Conditioning](https://www.amazon.de/Convict-Conditioning-Weakness-Using-Survival-Strength/dp/0938045768) book by Paul Wade. A User can login with their Google account, all data is then stored according to that.

## Look & Feel

![](https://i.imgur.com/vLITz4T.gif)

## Tech Stack

- The Frontend is written in [Elm](https://elm-lang.org/) and styled with [Bulma](https://bulma.io/)
- There is no real backend, data is simply synced to a [Firebase Cloud Firestore](https://firebase.google.com/docs/firestore), the database rules are setup as proposed in [this helpful blog post](https://lengrand.fr/using-firebase-in-elm/) by Julien Lengrand-Lambert


## Dev Setup
- You'll need to have [elm](https://guide.elm-lang.org/install/) and [create-elm-app](https://github.com/halfzebra/create-elm-app) installed
- You will also need to register at Firebase and setup a database, see blog post above
- Go to the project root directory
- Run `$ npm install` to install the firebase dependencies
- Prepare `.env` file with your firebase values as described in the blog post mentioned above
- Run `$ elm-app start`


## Known Issues
- Exercise names are currently hardcoded in german, need to be pulled from an external resource that allows adding translations to different languages


## Deployment

- `$ elm-app build`
- Copy `build` folder somewhere a web server is serving static files from
- E.g. a super simple nginx setup could look like:
  ```nginx
  server {
    listen 443;
    server_name your.domain.com;
    location / {
      root /var/www/convict;
      error_page 404 =200 /index.html;
    }
  }
  ```
- A simple deploy script could look then like:
   ```bash
    #!/bin/sh
    ssh username@hostname "mkdir -p /var/www/convict" && \
      scp -pr build/* username@hostname:/var/www/convict
   ```
   
