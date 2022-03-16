const jwt = require("jsonwebtoken");

function auth(req, res, next){
    try{
        // GETTING TOKEN
        let token = req.header("authorization");
        if(!token) return res.status(401).json({message: "Token not found. Authorization denied"});

        // VERIFYING TOKEN
        let verifiedToken = jwt.verify(token, process.env.JWT_SECRET);
        if(!verifiedToken) return res.status(401).json({message: "Token verification failed. Authorizarion denied"});

        req.user = verifiedToken.id;
        next();
    }
    catch(e){
        return res.status(500).json({message: `ERROR ${e}`});
    }
}

module.exports = auth;