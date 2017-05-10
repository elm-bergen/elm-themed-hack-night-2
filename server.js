const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');

const app = express();

let simpleUser = {
  firstName: 'first',
  lastName: 'last',
  age: 13
};

let mediumUser = {
  firstName: 'i am',
  lastName: 'medium',
  age: 14,
  height: 150.5,
  girth: 74.8,
  description: null
};

let complexUser = {
  firstName: '',
  lastName: 'medium',
  age: 14,
  favoritePets: [
    { type: 'Cat', name: 'CoolCatName', picture: null },
    { type: 'Dog', name: 'CoolDogName', picture: './pictures/user123/pets/fav_dog.png' },
    { type: 'Horse', name: 'CoolHorseName', picture: null }
  ],
  likesFlowers: true,
  friends: [
    simpleUser,
    mediumUser,
    mediumUser
  ]
};


app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.json());

app.get('/simple-user', (req, res) => {
  res.send(simpleUser);
});

app.get('/medium-user', (req, res) => {
  res.send(mediumUser);
});

app.get('/complex-user', (req, res) => {
  res.send(complexUser);
});

app.post('/simple-user', (req, res) => {
  simpleUser = req.body;
  console.log('gonna send', req);
  res.send(simpleUser);
});

app.listen(3000);
