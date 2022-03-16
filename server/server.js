const express = require("express");
const mongoose = require("mongoose");
const User = require("./user");
const Anime = require("./anime");
const auth = require("./middleware/auth");

require("dotenv").config();

const app = express();
const port = 3000;

module.exports = app;

async function connectDB(){
    try{
        await mongoose.connect(process.env.DB_PATH);
    }
    catch(e){
        console.log(`[ERROR] ${e}`);
    }
}

// CONNECT TO MONGO DB
connectDB();

// MIDDLEWARE FOR JSON EXTRACTION
app.use(express.json());

// MIDDLEWARE FOR ACCESS ON 'UPLOADS' FOLDER
app.use("/uploads/avatars", express.static(__dirname + "/uploads/avatars"));

// LISTENING TO PORT
app.listen(port, () => {
    console.log(`LISTENING TO PORT: ${port}`);
});

// USER ROUTES
app.post("/user/signup", User.signUp); // SIGN UP
app.post("/user/login", User.login); // LOGIN
app.get("/user/authenticate", User.authUser); // AUTHENTICATION
app.put("/user/update-password", auth, User.updatePassword); // UDPATE PASSWORD
app.put("/user/update-username", auth, User.updateUsername); // UPDATE USERNAME
app.put("/user/upload-photo", auth, User.uploadPhoto); // UPLOAD PHOTO

// ANIME ROUTES
app.post("/anime/add-anime", auth, Anime.addToHistory); // ADD ANIME HISTORY
app.get("/anime/detail", Anime.getDetails); // GET ANIME DETAILS
app.get("/anime/get-all-history", Anime.getAllHistory); // GET ALL ANIME HISTORY
app.delete("/anime/delete-anime", auth, Anime.deleteAnime); // DELETE ANIME HISTORY
app.post("/anime/verify-history", Anime.verifyHistory); // VERIFY IF THE USER HAS THE REQUESTED ANIME IN HIS/HER HISTORY