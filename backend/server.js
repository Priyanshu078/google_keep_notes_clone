// importing express 
const express = require("express");
// importing mongoose
const mongoose = require("mongoose");
const bodyParser = require('body-parser');
const app = express();
const PORT = 5000;

app.use(bodyParser.urlencoded({ extended:true }));
app.use(bodyParser.json());

// connecting mongoose database
mongoose
  .connect(
    "mongodb+srv://priyanshupaliwal:Pass%401234@cluster0.fcfkqqb.mongodb.net/?retryWrites=true&w=majority"
  )
  .then(() => {
    console.log("connected to MongoDB database");
    app.use('/api', require('./src/routes/notes'));
  });

// listening to the port 
app.listen(PORT, () =>{
  console.log(`Listening to PORT: ${PORT}`);
});
