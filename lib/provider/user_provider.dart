import 'dart:async';
import 'dart:convert';

import 'package:anime_history/constants.dart';
import 'package:anime_history/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  valid,
  invalid,
  error
}

class UserProvider extends ChangeNotifier{
  final ImagePicker _imagePicker = ImagePicker();

  // STREAM CONTROLLER
  StreamController<AuthStatus>? _authStreamController;

  // STREAMS
  Stream<AuthStatus> get authStream => _authStreamController!.stream;

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

  // INIT AUTH
  void initAuth(){
    _authStreamController = BehaviorSubject<AuthStatus>();
    auth();
  }

  void disposeAuth(){
    _authStreamController?.close();
    _authStreamController = null;
  }

  // SIGN UP
  Future<bool> signUp(String username, String email, String password) async {
    try{
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
          // ADD DATA ON AUTH STREAM
          _authStreamController?.sink.add(AuthStatus.valid);
          return true;
        }
        else{
          showShortToast(kCommonErrorMessage);
          return false;
        }
      }
      else if(res.statusCode == 400){
        showShortToast(parsedData['message']);
        return false;
      }
      else{
        // ADD DATA ON AUTH STREAM
        _authStreamController?.sink.add(AuthStatus.error);
        showShortToast(parsedData['message']);
        return false;
      }
    }
    catch(e){
      // ADD DATA ON AUTH STREAM
      _authStreamController?.sink.add(AuthStatus.error);
      showShortToast(kCommonErrorMessage);
      return false;
    }
  }

  // LOGIN
  Future<void> login(String email, String password) async {
    try{
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
          ? parsedData['data']['image']!
          : null;
        
        if(isPrefSaved){
          // ADD DATA ON AUTH STREAM
          _authStreamController?.sink.add(AuthStatus.valid);
          notifyListeners();
        }
        else{
          showShortToast(kCommonErrorMessage);
        }
      }
      else if(res.statusCode == 400){
        showShortToast(parsedData['message']);
      }
      else{
        // ADD DATA ON AUTH STREAM
        _authStreamController?.sink.add(AuthStatus.error);
        showShortToast(parsedData['message']);
      }
    }
    catch(e){
      // ADD DATA ON AUTH STREAM
      _authStreamController?.sink.add(AuthStatus.error);
      showShortToast(kCommonErrorMessage);
    }
  }

  // AUTHENTICATION
  void auth() async {
    var pref = await SharedPreferences.getInstance();
    
    // GET TOKEN IN THE LOCAL STORAGE
    var token = pref.getString('token');
    
    if(token != null){
      try{
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
            ? parsedData['data']['image']!
            : null;

          // ADD DATA ON AUTH STREAM
          _authStreamController?.sink.add(AuthStatus.valid);
          notifyListeners();
        }
        else if(res.statusCode == 401){
          // ADD DATA ON AUTH STREAM
          _authStreamController?.sink.add(AuthStatus.invalid);
        }
        else{
          // ADD DATA ON AUTH STREAM
          _authStreamController?.sink.add(AuthStatus.error);
        }
      }
      catch(e){
        // ADD DATA ON AUTH STREAM
        _authStreamController?.sink.add(AuthStatus.error);
        showShortToast(kCommonErrorMessage);
      }
    }
    else{
      // ADD DATA ON AUTH STREAM
      _authStreamController?.sink.add(AuthStatus.invalid);
    }
  }

  // LOGOUT
  void logout() async {
    var pref = await SharedPreferences.getInstance();

    // REMOVE TOKEN ON LOCAL STORAGE
    var isRemove = await pref.remove('token');

    if(isRemove){
      // ADD DATA ON AUTH STREAM
      _authStreamController?.sink.add(AuthStatus.invalid);
    }
    else{
      showShortToast(kCommonErrorMessage);
    }
  }

  // UPDATE USERNAME
  Future<bool> updateUsername(String newUsername) async {
    var pref = await SharedPreferences.getInstance();

    try{
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
        showShortToast(kCommonErrorMessage);
        return false;
      }
    }
    catch(e){
      showShortToast(kCommonErrorMessage);
      return false;
    }
  }
  
  // UPDATE PASSWORD
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    var pref = await SharedPreferences.getInstance();

    try{
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
        showShortToast(kCommonErrorMessage);
        return false;
      }
    }
    catch(e){
      showShortToast(kCommonErrorMessage);
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

      try{
        // PUT TO SERVER
        var res = await http.put(
          Uri.parse(kUploadPhotoUrl),
          headers: jsonHeaderWithToken(pref.getString('token') ?? ""),
          body: jsonEncode({
            'image_base64': base64Encode(imageBytes),
            'user_id': _id
          })
        );

        var parsedData = jsonDecode(res.body);

        if(res.statusCode == 200){
          _avatar = parsedData['data'];
          notifyListeners();
        }
        else{
          showShortToast(kCommonErrorMessage);
        }
      }
      catch(e){
        showShortToast(kCommonErrorMessage);
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

      try{
        // PUT TO SERVER
        var res = await http.put(
          Uri.parse(kUploadPhotoUrl),
          headers: jsonHeaderWithToken(pref.getString('token') ?? ""),
          body: jsonEncode({
            'image_base64': base64Encode(imageBytes),
            'user_id': _id
          })
        );

        var parsedData = jsonDecode(res.body);

        if(res.statusCode == 200){
          _avatar = parsedData['data'];
          notifyListeners();
        }
        else{
          showShortToast(kCommonErrorMessage);
        }
      }
      catch(e){
        showShortToast(kCommonErrorMessage);
      }
    }
  }
}