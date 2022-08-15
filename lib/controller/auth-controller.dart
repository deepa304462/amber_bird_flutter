import 'dart:developer';
import 'package:amber_bird/services/client-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var fieldValue = {
    'fullName': '',
    'email': '',
    'thirdPartyId': '',
    'imageFromSocialMedia': '',
    'isThirdParty': false,
    'thirdPartyName': '',
    'mobile': '',
    'password': '',
    'userName': ''
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
  signUp() async {
    // var payload = {
    //   "email": fieldValue['email'],
    //   "fullName": fieldValue['fullName'],
    //   "mobile": fieldValue['mobile'],
    //   "thirdPartyRef": {"name": "sbazar", "_id": "sbazar"
    //   },
    //   // "type": "string",
    //   "userName": fieldValue['userName'],

    //   "socialMediaOAuths": [
    //     {
    //       "type": fieldValue['thirdPartyName'],
    //       "socialMediaId": fieldValue['thirdPartyId'],
    //       "imageFromSocialMedia": fieldValue['imageFromSocialMedia'],
    //       // "verifiedAccountId": "string",
    //       // "username": "string",
    //       // "socialMediaName": "string",
    //       "socialMediaAvatar": fieldValue['imageFromSocialMedia']
    //     }
    //   ],
    // };
    var payload = {
      "suggestedUsername": fieldValue['email'],
      "orgRef": {"name": "sbazar", "_id": "sbazar"},
      // "orgShortCode": "string",
      "email": fieldValue['email'],
      "mobile": fieldValue['mobile'],
      "fullName": fieldValue['fullName'],
      // "deviceId": "string",
      // "tfaStatus": true,
      // "acls": ["string"],
      "profileType": "DIAGO_APP_PROFILE",
      "password": fieldValue['password'],
      // "notificationSetting": {
      //   "userHasDevice": "CUG_PHONE",
      //   "platform": ["ANDROID"]
      // }
    };
    print(payload);
    var resp = await ClientService.post(path: 'profile-auth', payload: payload);
    print(resp);
    inspect(resp);
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
        'thirdPartyId': googleSignInAuthentication!.idToken ?? '',
        'imageFromSocialMedia': googleSignInAccount.photoUrl ?? '',
        'isThirdParty': true,
        'thirdPartyName': 'GOOGLE',
        'mobile': '',
        'password': '',
        'userName': ''
      };
    }
  }

  void setFielsvalue(String text, String name) {
    fieldValue.value[name] = text;
    print(fieldValue);
  }
}
