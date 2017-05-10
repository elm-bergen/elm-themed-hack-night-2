# Elm themed hack night #2. Encoders and decoders



### Install

Make sure you have `elm` and `npm` installed. `npm` usually comes bundled with `nodejs` and `elm` install instrutions can be found at elm-lang.org

Make sure you are in the root folder of the project, then run:

`npm install`  
`elm-package install`


### Run it

Right now you need to have 2 separate processes if you want to run and watch both the server and the elm code.

To run and watch elm code: `npm run elm`  
To run and watch server: `npm run server`

You should now see something at localhost:3000, if it compiles


### Task

Fill in the decoder and encoder for "medium user".

Bonus: For those who solve the "medium user", there's a "complex user" on the server. Check out `server.js` to see it's structure. Make a GET request and decoder to get it at `/complex-user`

Extra bonus: POST a medium user


### Resources

- http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Encode
- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Decode
- http://package.elm-lang.org/packages/circuithub/elm-json-extra/latest/Json-Decode-Extra
