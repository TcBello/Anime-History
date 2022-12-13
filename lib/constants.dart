// JIKAN MOE BASE API
const String kBaseApi = "https://api.jikan.moe/v4";

// BACKGROUND IMAGE PATH OF SPLASHSCREEN
const String kSplashScreenImage = "assets/imgs/splashscreen_image.jpg";

// BACKGROUND IMAGE PATH OF LOGIN SCREEN
const String kLoginBackgroundPath = "assets/imgs/login_bg.jpg";

// APP ICON IMAGE PATH
const String kAppIconImagePath = "assets/imgs/app_icon.png";

// CONNECTION
const String vercel = "anime-history-server.vercel.app";

// URL ROUTES
const String kSignUpUrl = "https://$vercel/user/signup"; // SIGN UP
const String kLoginUrl = "https://$vercel/user/login"; // LOGIN
const String kAuthenticationUrl = "https://$vercel/user/authenticate"; // AUTHENTICATE
const String kUpdateUsernameUrl = "https://$vercel/user/update-username"; // UPDATE USERNAME
const String kUpdatePasswordUrl = "https://$vercel/user/update-password"; // UPDATE PASSWORD
const String kUploadPhotoUrl = "https://$vercel/user/upload-photo"; // UPLOAD PHOTO
const String kAddAnimeUrl = "https://$vercel/anime/add-anime"; // ADD ANIME
const String kAnimeDetailUrl = "https://$vercel/anime/detail"; // ANIME DETAIL
const String kAllAnimeHistoryUrl = "https://$vercel/anime/get-all-history"; // GET ALL ANIME HISTORY
const String kDeleteAnimeUrl = "https://$vercel/anime/delete-anime"; // DELETE ANIME
const String kVerifyAnimeHistoryUrl = "https://$vercel/anime/verify-history"; // VERIFY ANIME HISTORY

// JSON HEADER
const Map<String, String> kJsonHeader = {
  'Content-type': 'application/json',
  'Accept': 'application/json'
}; 

// COMMON ERROR MESSAGE
const String kCommonErrorMessage = "Something went wrong. Please try again later!";