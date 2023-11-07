// importing express 
const express = require("express");
// importing mongoose
const mongoose = require("mongoose");
const bodyParser = require('body-parser');
const app = express();
const PORT = 3000;

const notesRoute = require('./routes/notes')

app.use(bodyParser.urlencoded({ extended:true }));
app.use(bodyParser.json());


app.use('/', notesRoute);

// listening to the port 
app.listen(PORT, () =>{
  console.log(`Listening to PORT: ${PORT}`);
  // connecting mongoose database
  mongoose
    .connect(
      // replace this with your own mongodb atlas connection url
      "mongodb+srv://priyanshupaliwal:Pass%401234@cluster0.fcfkqqb.mongodb.net/?retryWrites=true&w=majority"
    )
    .then(() => {
      console.log("connected to MongoDB database");
    });
});
