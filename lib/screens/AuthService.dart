
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


import '../config/config.dart';


class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  Future  signinWithGoggle() async {
    try{
      //User currentUser;
     final  GoogleSignInAccount googleuser = await googleSignIn.signIn();
     print(googleuser);

      if (googleuser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleuser.authentication;
        print(googleAuth);


       final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        print(credential);

        User? user =( await _auth.signInWithCredential(credential)).user;
        print(user!.providerData);
        readEmailSignInUserData();
        FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).set({
          "uid": _auth.currentUser!.uid,
          "email":_auth.currentUser!.email,
          "name":  _auth.currentUser!.displayName,
          "phone":  'Update your Phone number..',
          "address": 'Update your address..',
          // "url": userImage,
          // AutoParts.userCartList: ["garbageValue"],
        });
        await AutoParts.preferences!.setString("uid", _auth.currentUser!.uid);
       // await AutoParts.preferences!.setString("photoUrl", _auth.currentUser.photoURL);







      }


    }catch(e){
      print(e);
    }


  }



  Future<void> signoutgoogle() async {
    await googleSignIn.signOut();
    await AutoParts.preferences!.clear();
    print("user signed out");
  }


  Future readEmailSignInUserData() async {
    await AutoParts.preferences!
        .setString("uid", _auth.currentUser!.uid);
    // await AutoParts.preferences!.setString(
    //     AutoParts.userEmail, _auth.currentUser.email);
    // await AutoParts.preferences!.setString(
    //     AutoParts.userName, _auth.currentUser.displayName);


    }




  }


