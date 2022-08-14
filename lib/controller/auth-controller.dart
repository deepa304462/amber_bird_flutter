import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var fieldValue = {
    'fullName': '',
    'email': '',
    'id': '',
    'imageFromSocialMedia': '',
    'isThirdParty': false,
    'name': 'Google',
    'mobile': '',
    'password': ''
  }.obs;
  @override
  void onInit() {
    initializeFirebase();
    super.onInit();
  }

  initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
  }

  login() {
    // var data = signInWithGoogle();
  }

  signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    inspect(googleSignInAccount);
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      inspect(googleSignInAuthentication);
      print('credetails${googleSignInAuthentication.accessToken}');
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      print('credetails${credential}');
      fieldValue.value = {
        'fullName': googleSignInAccount.displayName ?? '',
        'email': googleSignInAccount.email,
        'id': googleSignInAuthentication!.idToken ?? '',
        'imageFromSocialMedia': googleSignInAccount.photoUrl ?? '',
        'isThirdParty': true,
        'name': 'Google',
        'mobile': '',
        'password': ''
      };

      
    }
  }
}
