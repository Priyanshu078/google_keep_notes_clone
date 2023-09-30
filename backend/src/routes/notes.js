const express = require("express");
const router = express.Router();
const Note = require("../models/Note");

router.post("/getNotes", async (req, res) => {
  const notes = await Note.find({ userid: req.body.userid, trashed: req.body.trashed, archived: req.body.archived });
  if ((req.body.trashed == false)&& (req.body.archived == false)) {
    // let pinnedNotes = await Note.find({ userid: req.body.userid, trashed: req.body.trashed, archived: req.body.archived, pinned: true });
    // let otherNotes = await Note.find({ userid: req.body.userid, trashed: req.body.trashed, archived: req.body.archived, pinned: false })
    let pinnedNotes = [];
    let otherNotes = [];
    for(var i = 0;i<notes.length;i++){
      if(notes[i]['pinned'] == true){
        pinnedNotes.push(notes[i]);
      }
      else{
        otherNotes.push(notes[i]);
      }
    }
    res.json({
      pinned: pinnedNotes,
      others: otherNotes,
    });
  }
  else {
    
    res.json(notes);
  }
});

router.post("/addNotes", async (req, res) => {
  const newNote = await Note({
    id: req.body.id,
    userid: req.body.userid,
    title: req.body.title,
    content: req.body.content,
    pinned: req.body.pinned,
    colorIndex: req.body.colorIndex,
    trashed: req.body.trashed,
    archived: req.body.archived,
    dateadded: req.body.dateadded
  });
  try {
    await newNote.save();
    res.json({ status: 200, message: "Note added successfully" });
  } catch (e) {
    res.json({
      status: 400,
      message: "Something went wrong",
      error: e.toString(),
    });
  }
});

router.post("/updateNotes", async (req, res) => {
  try {
    const doc = await Note.findOne({ id: req.body.id });
    const update = {
      title: req.body.title,
      content: req.body.content,
      pinned: req.body.pinned,
      colorIndex: req.body.colorIndex,
      trashed: req.body.trashed,
      archived: req.body.archived,
      dateadded : req.body.dateadded,
    };
    await doc.updateOne(update);
    res.send({ status: 200, message: "document updated succussfully" });
  } catch (e) {
    res.send({
      status: 400,
      message: "somthing went wrong",
      error: e.toString(),
    });
  }
});

router.post('/deleteNotes', async (req, res) => {
  try {
    await Note.deleteOne({ id: req.body.id });
    res.send({ status: 200, message: "document deleted succussfully" });
  }
  catch (e) {
    res.send({
      status: 400,
      message: "somthing went wrong",
      error: e.toString(),
    });
  }
});

router.post('/emptyTrash', async (req, res) => {
  try {
    await Note.deleteMany({ trashed: true });
    res.send({ status: 200, message: "removed everything from Trash" });
  }
  catch (e) {
    res.send({
      status: 400,
      message: "Something Went Wrong",
      error: e.toString(),
    })
  }
});

module.exports = router;
