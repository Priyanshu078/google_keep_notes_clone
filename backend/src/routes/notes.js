const express = require("express");
const router = express.Router();
const Note = require("../models/Note");

router.post("/getNotes", async (req, res) => {
  const notes = await Note.find({ userid: req.body.userid });
  res.json(notes);
});

router.post("/addNotes", async (req, res) => {
  const newNote = await Note({
    id: req.body.id,
    userid: req.body.userid,
    title: req.body.title,
    content: req.body.content,
    pinned: req.body.pinned,
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

router.post('/deleteNotes', async(req,res) =>{
    try{
        await Note.deleteOne({id : req.body.id});
        res.send({ status: 200, message: "document deleted succussfully" });
    }
    catch(e){
        res.send({
            status: 400,
            message: "somthing went wrong",
            error: e.toString(),
          });
    }
});

module.exports = router;
