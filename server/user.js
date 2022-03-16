const User = require("./models/user_model");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const multer = require("multer");


// MULTER'S STORAGE CONFIGURATION FOR BETTER CONTROL OF UPLOADING FILE IN THE SERVER
const storage = multer.diskStorage({
    destination: function(req, file, cb){
        cb(null, "uploads/avatars");
    },
    filename: function(req, file, cb) {
        cb(null, `${Date.now()}-${file.originalname}`);
    }
});

const upload = multer({storage: storage}).single("photo");

// SIGN UP
async function signUp(req, res){
    // FIND EXISTING EMAIL
    let existingEmail = await User.findOne({email: req.body.email});
    if(existingEmail){
        return res.status(400).json({message: "Email already been used"});
    }
    else{
        try{
            // GENERATE ENCRPYTED PASSWORD
            let salt = await bcrypt.genSalt();
            let passHash = await bcrypt.hash(req.body.password, salt);
            req.body.password = passHash;

            // MAPPING JSON REQUEST TO USER MODEL
            let user = new User(req.body);

            // SAVE USER TO DATABASE
            await user.save();

            // SIGN IN TOKEN
            let token = jwt.sign({id: user._id}, process.env.JWT_SECRET);

            return res.status(200).json({
                message: `Create User ${req.body.username} successfully`,
                token: token
            });
        }
        catch(e){
            return res.status(500).json({message: `[ERROR] ${e} :: ${req.body.password}`});
        }
    }
}

// LOGIN
async function login(req, res){
    try{
        // FIND EXISTING EMAIL
        let user = await User.findOne({email: req.body.email});
        if(!user) return res.status(400).json({message: "User is not registed with this email"});

        // COMPARING INPUT PASSWORD WITH ENCRYPTED PASSWORD FROM DATABASE
        let isPasswordMatch = await bcrypt.compare(req.body.password, user.password);
        if(!isPasswordMatch) return res.status(400).json({message: "Incorrect email or password"});

        // SIGN IN TOKEN
        let token = jwt.sign({id: user._id}, process.env.JWT_SECRET);

        return res.status(200).json({
            message: "Login successfully",
            token: token,
            data: {
                id: user._id,
                username: user.username,
                email: user.email,
                image: user.image
            }
        });
    }
    catch(e){
        return res.status(500).json({message: `[ERROR] ${e}`});
    }
}

// UPDATE PASSWORD
async function updatePassword(req, res){
    try{
        let oldPassword = req.body.oldPassword;
        let newPassword = req.body.newPassword;

        // FIND EXISTING EMAIL
        let user = await User.findOne({email: req.body.email});

        // COMPARE CURRENT PASSWORD TO ENCRYPTED PASSWORD FROM DATABASE
        let isPasswordMatch = await bcrypt.compare(oldPassword, user.password);

        // GENERATE SALT FOR BCRYPT HASH
        let salt = await bcrypt.genSalt();

        if(isPasswordMatch){
            // ASSIGNING NEW PASSWORD
            user.password = await bcrypt.hash(newPassword, salt);
            await user.save();

            return res.status(200).json({message: "Password updated successfully"});
        }
        else{
            return res.status(400).json({message: "Wrong Credentials"});
        }
    }
    catch(e){
        return res.status(500).json({message: `[ERROR] ${e}`});
    }
}

// UPDATE USERNAME
async function updateUsername(req, res){
    try{
        // FIND EXISTING EMAIL
        let user = await User.findOne({email: req.body.email});

        // ASSIGN NEW USERNAME
        user.username = req.body.newUsername;
        await user.save();
        
        return res.status(200).json({message: "Update username successfully"});
    }
    catch(e){
        return res.status(500).json({message: `[ERROR]: ${e}`});
    }
}

// Authentication of the User
async function authUser(req, res){
    try{
        // GETTING TOKEN
        let token = req.header("authorization");
        if(!token) return res.status(401).json({message: "Token not found. Authorization denied"});

        // VERIFYING TOKEN
        let verifiedToken = jwt.verify(token, process.env.JWT_SECRET);
        if(!verifiedToken) return res.status(401).json({message: "Token verification failed. Authorizarion denied"});

        // FINDING THE VERIFIED USER'S TOKEN BY ID
        let user = await User.findById(verifiedToken.id);

        return res.status(200).json({
            message: "Verified token found",
            data:{
                id: user._id,
                username: user.username,
                email: user.email,
                image: user.image
            }
        });
    }
    catch(e){
        return res.status(500).json({message: `ERROR ${e}`});
    }
}

function uploadPhoto(req, res){
    upload(req, res, async (error) => {
        if(!error){
            // FINDING EXISTING USER'S ID
            let user = await User.findById(req.body['user_id']);

            if(user){
                // ASSIGN A NEW IMAGE PATH
                user.image = `uploads/avatars/${req.file.filename}`;

                await user.save();
                return res.status(200).json({message: "Uploaded successfully", data: user.image});
            }
            else{
                return res.status(400).json({message: "Can't find the current user"});
            }
        }
        else{
            console.log(error);
            return res.status(500).json({message: "Something went wrong on uploading image"});
        }
    });
}

module.exports.signUp = signUp;
module.exports.login = login;
module.exports.updatePassword = updatePassword;
module.exports.updateUsername = updateUsername;
module.exports.authUser = authUser;
module.exports.uploadPhoto = uploadPhoto;