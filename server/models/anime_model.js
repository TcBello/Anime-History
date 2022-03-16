const mongoose = require("mongoose");

const anime = new mongoose.Schema({
    id: {
        type: Number,
        required: true
    },
    userId: {
        type: String,
        required: true
    },
    url: {
        type: String,
        required: true
    },
    image: {
        type: String,
        required: true
    },
    title: {
        type: String,
        required: true
    },
    titleJapanese: {
        type: String,
        default: ""
    },
    titleEnglish: {
        type: String,
        default: ""
    },
    titleSynonyms: {
        type: Array,
        default: []
    },
    airing: {
        type: Boolean,
        default: false
    },
    status: {
        type: String,
        default: ""
    },
    synopsis: {
        type: String,
        default: "No Summary Available"
    },
    duration: {
        type: String,
        default: ""
    },
    rank: {
        type: Number,
        default: 0
    },
    producers: {type: Array},
    studios: {type: Array},
    licensors: {type: Array},
    genres: {type: Array},
    source: {
        type: String,
        default: ""
    },
    type: {
        type: String,
        default: ""
    },
    episodes: {
        type: String,
        default: "Unknown"
    },
    rating: {
        type: Number,
        default: 0
    },
    startDate: {
        type: String,
        default: ""
    },
    endDate: {
        type: String,
        default: ""
    },
    rated: {
        type: String,
        default: ""
    },
});

module.exports = mongoose.model("Anime", anime);