import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:uber_clone/constants/user_settings/ride_verification.dart' as fields;
import 'package:uber_clone/models/signed_in_type.dart';
import 'package:uber_clone/models/user_data.dart';
import 'package:uber_clone/services/secure_storage.dart';
import 'package:uber_clone/user_data_fields.dart' as user_data_fields;

import 'file:///C:/Users/semir/FlutterProjects/uber-clone/uber_clone/lib/services/firebase/firestore_service.dart';
class AuthenticationService{

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  UserData _userData;
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  AuthenticationService(this._firebaseAuth) {
    if(_firebaseAuth.currentUser != null) {
      _loadUser();
    }
  }

  UserData get currentUserData => _userData;
  User get currentUser => _firebaseAuth.currentUser;

  Future<void> _loadUser() async {
    _userData = await SecureStorage.loadUser();
  }

  _parseGoogleToken(String token ) {
    if(token == null) return null;
    final List<String> parts = token.split('.');
    if(parts.length != 3) return null;

    final String payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String resp = utf8.decode(base64Url.decode(normalized));

    final payloadMap = json.decode(resp);
    if( payloadMap is! Map<String, dynamic>) {
      return null;
    }

    final String firstName = payloadMap["given_name"];
    final String lastName = payloadMap["family_name"];

    print("First name: " + firstName);
    print("Last name: " + lastName);
    return payloadMap;


  }




  Future<UserData> signInWithGoogle() async{
    try {
      final GoogleSignInAccount accountUser = await _googleSignIn.signIn();


      // accountUser would be null if account is not picked
      if(accountUser != null) {
        final GoogleSignInAuthentication googleAuth = await accountUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken
        );
        await _firebaseAuth.signInWithCredential(credential);
        final payloadMap = _parseGoogleToken(googleAuth.idToken);

        final Map<String, dynamic> data = {
          user_data_fields.firstName : payloadMap["given_name"],
          user_data_fields.lastName : payloadMap["family_name"],
          user_data_fields.email : accountUser.email,
          user_data_fields.providerUserId : accountUser.id,
          user_data_fields.profilePicture : accountUser.photoUrl,
          user_data_fields.signedInType : SignedInType.Google.parseSignedInType(),
          user_data_fields.firebaseUserId : FirebaseAuth.instance.currentUser.uid,
          user_data_fields.phoneNumber : '2225'
        };

        // initialize attribute with gathered data
        _userData = UserData.fromMap(data);

        //save custom user data to SecureStorage and Firestore
        await FirebaseFirestore.instance.collection('user_settings').doc(FirebaseAuth.instance.currentUser.uid).set({
          fields.isUserUsingPIN  : false,
          fields.isNightTimeOnly : false
        });
        await SecureStorage.saveUser(_userData);
        await FirestoreService.saveUser(_userData);
        return _userData;
      }
      return null;
    } on Exception catch(_) {
      print("Error login with google!");
      return null;
    }
  }

  Future<UserData> signInWithFacebook() async {
    try {
       final AccessToken  accessToken = await FacebookAuth.instance.login();
       final AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
       await _firebaseAuth.signInWithCredential(credential);
       String url = 'https://graph.facebook.com/v9.0/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}';
       http.Response x = await http.get(url);
       final profile = json.decode(x.body);
       print(profile);

       final Map<String, dynamic> data = {
         user_data_fields.firstName : profile["first_name"],
         user_data_fields.lastName : profile["last_name"],
         user_data_fields.email : profile["email"],
         user_data_fields.providerUserId : profile["id"],
         user_data_fields.profilePicture : FirebaseAuth.instance.currentUser.photoURL,
         user_data_fields.signedInType : SignedInType.Facebook,
         user_data_fields.firebaseUserId : FirebaseAuth.instance.currentUser.uid,
         user_data_fields.phoneNumber : '2225'
       };


       // initialize attribute with gathered data
       _userData = UserData.fromMap(data);

       //save the custom user data to SecureStorage and Firestore
       await FirebaseFirestore.instance.collection('user_settings').doc(FirebaseAuth.instance.currentUser.uid).set({
         fields.isUserUsingPIN  : false,
         fields.isNightTimeOnly : false
       });
       await SecureStorage.saveUser(_userData);
       await FirestoreService.saveUser(_userData);

       return _userData;
     } on FacebookAuthException catch(error) {
        print(error.errorCode);
        return null;
     }

  }


  Future<bool> isLoggedInWithFacebook() async {
    return (await FacebookAuth.instance.isLogged) != null;
  }
  Future<bool> isLoggedInWithGoogle() async {
    return (await _googleSignIn.isSignedIn());
  }


  Future<void> signOut() async {
    if( await isLoggedInWithFacebook()) {
      await FacebookAuth.instance.logOut();
    }
    else {
      await _googleSignIn.signOut();
    }

    await FirebaseAuth.instance.signOut();

  }

}