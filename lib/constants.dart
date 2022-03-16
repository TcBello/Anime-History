// JIKAN MOE BASE API
const String kBaseApi = "https://api.jikan.moe/v4";

// BACKGROUND IMAGE PATH OF SPLASHSCREEN
const String kSplashScreenImage = "assets/imgs/splashscreen_image.jpg";

// BACKGROUND IMAGE PATH OF LOGIN SCREEN
const String kLoginBackgroundPath = "assets/imgs/login_bg.jpg";

// APP ICON IMAGE PATH
const String kAppIconImagePath = "assets/imgs/app_icon.png";

// CONNECTION
const String heroku = "animehistory.herokuapp.com";

// URL ROUTES
const String kSignUpUrl = "https://$heroku/user/signup"; // SIGN UP
const String kLoginUrl = "https://$heroku/user/login"; // LOGIN
const String kAuthenticationUrl = "https://$heroku/user/authenticate"; // AUTHENTICATE
const String kUpdateUsernameUrl = "https://$heroku/user/update-username"; // UPDATE USERNAME
const String kUpdatePasswordUrl = "https://$heroku/user/update-password"; // UPDATE PASSWORD
const String kUploadPhotoUrl = "https://$heroku/user/upload-photo"; // UPLOAD PHOTO
const String kAddAnimeUrl = "https://$heroku/anime/add-anime"; // ADD ANIME
const String kAnimeDetailUrl = "https://$heroku/anime/detail"; // ANIME DETAIL
const String kAllAnimeHistoryUrl = "https://$heroku/anime/get-all-history"; // GET ALL ANIME HISTORY
const String kDeleteAnimeUrl = "https://$heroku/anime/delete-anime"; // DELETE ANIME
const String kVerifyAnimeHistoryUrl = "https://$heroku/anime/verify-history"; // VERIFY ANIME HISTORY

// JSON HEADER
const Map<String, String> kJsonHeader = {
  'Content-type': 'application/json',
  'Accept': 'application/json'
}; 