import 'dart:convert';

import 'package:anime_history/constants.dart';
import 'package:anime_history/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier{
  final ImagePicker _imagePicker = ImagePicker();

  // ID OF CURRENT LOGGED IN USER
  String _id = "";
  String get id => _id;

  // EMAIL OF CURRENT LOGGED IN USER
  String _email = "";
  String get email => _email;

  // USERNAME OF CURRENT LOGGED IN USER
  String _username = "";
  String get username => _username;

  // AVATAR OF THE CURRENT USER
  String? _avatar = "";
  String? get avatar => _avatar;

  // ERROR MESSAGE
  // ignore: prefer_final_fields
  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  // SIGN UP
  Future<bool> signUp(String username, String email, String password) async {
    // POST TO SERVER
    var res = await http.post(
      Uri.parse(kSignUpUrl),
      headers: kJsonHeader,
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password
      })
    );

    // DECODE JSON
    var parsedData = jsonDecode(res.body);

    if(res.statusCode == 200){
      // SAVE TOKEN TO LOCAL STORAGE
      var pref = await SharedPreferences.getInstance();
      var isPrefSaved = await pref.setString('token', parsedData['token']);
      
      if(isPrefSaved){
        return true;
      }
      else{
        showShortToast("Something went wrong! Please Try Again");
        return false;
      }
    }
    else if(res.statusCode == 400){
      showShortToast(parsedData['message']);
      return false;
    }
    else{
      showShortToast(parsedData['message']);
      return false;
    }
  }

  // LOGIN
  void login(String email, String password) async {
    // POST TO SERVER
    var res = await http.post(
      Uri.parse(kLoginUrl),
      headers: kJsonHeader,
      body: jsonEncode({
        'email': email,
        'password': password
      })
    );

    // DECODE JSON
    var parsedData = jsonDecode(res.body);

    if(res.statusCode == 200){
      // SAVE TOKEN TO LOCAL STORAGE
      var pref = await SharedPreferences.getInstance();
      var isPrefSaved = await pref.setString('token', parsedData['token']);

      // ASSIGNING DATA OF THE LOGGED IN USER
      _id = parsedData['data']['id'];
      _username = parsedData['data']['username'];
      _email = parsedData['data']['email'];
      _avatar = parsedData['data']['image'] != null
        ? avatarUrl(parsedData['data']['image'])
        : null;
      
      if(isPrefSaved){
        notifyListeners();
      }
      else{
        showShortToast("Something went wrong! Please Try Again");
      }
    }
    else if(res.statusCode == 400){
      showShortToast(parsedData['message']);
    }
    else{
      showShortToast(parsedData['message']);
    }
  }

  // AUTHENTICATION
  Future<bool> auth() async {
    var pref = await SharedPreferences.getInstance();
    
    // GET TOKEN IN THE LOCAL STORAGE
    var token = pref.getString('token');
    
    if(token != null){
      // GET REQUEST TO SERVER
      var res = await http.get(
        Uri.parse(kAuthenticationUrl),
        headers: {
          'authorization': token
        }
      );

      // DECODE JSON
      var parsedData = jsonDecode(res.body);

      if(res.statusCode == 200){

        // ASSIGNING DATA OF THE CURRENT LOGGED IN USER
        _id = parsedData['data']['id'];
        _username = parsedData['data']['username'];
        _email = parsedData['data']['email'];
        _avatar = parsedData['data']['image'] != null
          ? avatarUrl(parsedData['data']['image'])
          : null;

        notifyListeners();
        return true;
      }
      else{
        notifyListeners();
        return false;
      }
    }
    else{
      notifyListeners();
      return false;
    }
  }

  // LOGOUT
  void logout() async {
    var pref = await SharedPreferences.getInstance();

    // REMOVE TOKEN ON LOCAL STORAGE
    var isRemove = await pref.remove('token');

    if(isRemove){
      notifyListeners();
    }
    else{
      showShortToast("Something went wrong!");
    }
  }

  // UPDATE USERNAME
  Future<bool> updateUsername(String newUsername) async {
    var pref = await SharedPreferences.getInstance();

    // PUT TO SERVER
    var res = await http.put(
      Uri.parse(kUpdateUsernameUrl),
      headers: jsonHeaderWithToken(pref.getString('token') ?? ""),
      body: jsonEncode({
        'email': _email,
        'newUsername': newUsername
      })
    );

    if(res.statusCode == 200){
      // ASSIGNING NEW USERNAME
      _username = newUsername;
      notifyListeners();
      showShortToast("Applied changes");
      return true;
    }
    else{
      showShortToast("Something went wrong! Please try again later");
      return false;
    }
  }
  
  // UPDATE PASSWORD
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    var pref = await SharedPreferences.getInstance();

    // PUT TO SERVER
    var res = await http.put(
      Uri.parse(kUpdatePasswordUrl),
      headers: jsonHeaderWithToken(pref.getString('token') ?? ""),
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'email': _email
      })
    );

    var parsedData = jsonDecode(res.body);

    if(res.statusCode == 200){
      showShortToast("Applied changes");
      return true;
    }
    else if(res.statusCode == 400){
      showShortToast(parsedData['message']);
      return false;
    }
    else{
      showShortToast("Something went wrong! Please try again later");
      return false;
    }
  }

  // GET IMAGE FROM GALLERY
  Future<void> uploadPhotoFromGallery() async {
    var pref = await SharedPreferences.getInstance();
    // PICK IMAGE
    var file = await _imagePicker.pickImage(source: ImageSource.gallery);
    
    if(file != null){
      var imageBytes = await file.readAsBytes();

      // REQUEST
      var req = http.MultipartRequest("PUT", Uri.parse(kUploadPhotoUrl));
      req.headers.addAll(jsonHeaderWithToken(pref.getString('token') ?? ""));
      req.fields['user_id'] = _id;
      req.files.add(http.MultipartFile.fromBytes('photo', imageBytes, filename: file.name));

      // SEND REQUEST TO THE SERVER
      var res = await req.send();
      var newResponse = await http.Response.fromStream(res);
      var parsedData = jsonDecode(newResponse.body);

      if(res.statusCode == 200){
        _avatar = avatarUrl(parsedData['data']);
        notifyListeners();
      }
      else{
        showShortToast("Something went wrong. Please try again later");
      }
    }
  }

  // GET IMAGE FROM CAMERA
  Future<void> uploadPhotoFromCamera() async {
    var pref = await SharedPreferences.getInstance();
    // PICK IMAGE
    var file = await _imagePicker.pickImage(source: ImageSource.camera);
    
    if(file != null){
      var imageBytes = await file.readAsBytes();

      // REQUEST
      var req = http.MultipartRequest("PUT", Uri.parse(kUploadPhotoUrl));
      req.headers.addAll(jsonHeaderWithToken(pref.getString('token') ?? ""));
      req.fields['user_id'] = _id;
      req.files.add(http.MultipartFile.fromBytes('photo', imageBytes, filename: file.name));

      // SEND REQUEST TO THE SERVER
      var res = await req.send();
      var newResponse = await http.Response.fromStream(res);
      var parsedData = jsonDecode(newResponse.body);

      if(res.statusCode == 200){
        _avatar = avatarUrl(parsedData['data']);
        notifyListeners();
      }
      else{
        showShortToast("Something went wrong. Please try again later");
      }
    }
  }
}