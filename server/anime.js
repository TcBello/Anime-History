const Anime = require('./models/anime_model');

// ADD ANIME HISTORY
async function addToHistory(req, res){
    try{
        // MAPPING JSON REQUEST TO ANIME MODEL
        let anime = new Anime(req.body);
        await anime.save();

        res.status(200).json({message: "Anime has been added to history"});
    }
    catch(e){
        res.status(500).json({message: `[ERROR] ${e}`})
    }
}

// GET ANIME
function getDetails(req, res){
    // FIND ANIME BY ID
    Anime.find({id: req.body.id}, (error, data) => {
        if(!error){
            return res.status(200).json({
                date: data,
                message: "Anime get details successfully"
            });
        }
        else{
            return res.status(500).json({message: `[ERROR]: ${error}`});
        }
    });
}


// GET ALL ANIME HISTORY
function getAllHistory(req, res){
    // FIND ALL ANIME BY LOGGED IN USER ID
    Anime.find({userId: req.header("request-user-id")}, (error, data) => {
        if(error){
            res.status(500).json({message: `[ERROR] ${e}`});
        }
        else{
            res.status(200).json({
                message: "Data successfully retreived",
                data: data
            });
        }
    });
}

// DELETE ANIME
function deleteAnime(req, res){
    // FIND ANIME BY ID AND DELETE WHEN FOUND
    Anime.findOneAndDelete({id: req.body.id}, (error, data) => {
        if(error){
            res.status(500).json({message: `[ERROR] ${error}`});
        }
        else{
            res.status(200).json({
                message: "Anime deleted successfully",
                data: data
            });
        }
    });
}

async function verifyHistory(req, res){
    try{
        var data = await Anime.findOne({id: req.body.id, userId: req.body.userId});

        if(data){
            return res.status(200).json({message: "Anime found", data: data});
        }
        else{
            return res.status(400).json({message: "Anime not found"});
        }
    }
    catch(e){
        return res.status(500).json({message: `[ERROR] ${error}`});
    }
}

module.exports.addToHistory = addToHistory;
module.exports.getAllHistory = getAllHistory;
module.exports.deleteAnime = deleteAnime;
module.exports.getDetails = getDetails;
module.exports.verifyHistory = verifyHistory;