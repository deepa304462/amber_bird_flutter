import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

enum LoginType {
  usernamePassword,
  mobilePassword,
  emailPassword,
  googleToken,
  fbToken
}

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
    'userName': '',
    'countryCode': ''
  }.obs;
  var loginWith = LoginType.emailPassword.obs;
  @override
  void onInit() {
    initializeFirebase();
    super.onInit();
  }

  setLoginWith(key) {
    loginWith.value = key;
  }

  initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
  }

  login() async {
    var loginPayload = {
      "password": fieldValue['password'],
      "username": fieldValue['email'],
      // "appName": "DIAGO_TEAM_WEB_APP"
    };
    if (loginWith.value == LoginType.usernamePassword) {
      loginPayload = {
        "password": fieldValue['password'],
        "userName": fieldValue['username'],
        // "appName": "DIAGO_TEAM_WEB_APP"
      };
    } else if (loginWith.value == LoginType.emailPassword) {
      loginPayload = {
        "password": fieldValue['password'],
        "email": fieldValue['email'],
        // "appName": "DIAGO_TEAM_WEB_APP"
      };
    } else if (loginWith.value == LoginType.mobilePassword) {
      loginPayload = {
        "password": fieldValue['password'],
        "mobile": fieldValue['countryCode'].toString() +
            fieldValue['mobile'].toString(),
        // "appName": "DIAGO_TEAM_WEB_APP"
      };
    } else if (loginWith.value == LoginType.googleToken) {
      loginPayload = {
        "socialMediaId": fieldValue['thirdPartyId'].toString(),
        "appName": "DIAGO_TEAM_WEB_APP"
      };
    }
    print('dfdfv${loginPayload}');
    inspect(loginPayload);
    var loginResp = await ClientService.post(
        path: 'auth/authenticate', payload: loginPayload);

    print(loginResp);

    if (loginResp.statusCode == 200) {
      ClientService.token = loginResp.data['accessToken'];
      SharedData.save(jsonEncode(loginResp.data), 'authData');
      var searchPAyload = {
        "type": "DIAGO_APP_PROFILE",
        "email": fieldValue['email'],
        "userName": fieldValue['email']
      };
      print(searchPAyload);
      var userUpdateResp = await ClientService.post(
          path: 'user-profile/search', payload: searchPAyload);
      print(userUpdateResp);
      if (userUpdateResp.statusCode == 200) {
        SharedData.save(userUpdateResp.data.toString(), 'userData');
        SharedData.save(true.toString(), 'isLogin');
        return {"msg": "Login Successfully!!", "status": "success"};
      } else {
        return {"msg": "Something Went Wrong!!", "status": "error"};
      }
    } else {
      return {"msg": "Something Went Wrong!!", "status": "error"};
    }
  }

  dynamic signUp() async {
    var payload = {
      "suggestedUsername": fieldValue['email'],
      "orgRef": {"name": "sbazar", "_id": "sbazar"},
      "email": fieldValue['email'],
      "mobile": fieldValue['countryCode'].toString() +
          fieldValue['mobile'].toString(),
      "fullName": fieldValue['fullName'],
      "acls": ["user"],
      "profileType": "DIAGO_APP_PROFILE",
      "password": fieldValue['password'],
    };
    var resp = await ClientService.post(path: 'profile-auth', payload: payload);
    if (resp.statusCode == 200) {
      SharedData.save(jsonEncode(resp.data), 'ProfileAuthData');
      print(resp);
      var loginPayload = {
        "password": fieldValue['password'],
        "userName": fieldValue['email'],
        // "appName": "DIAGO_TEAM_WEB_APP"
      };
      print(loginPayload);
      var loginResp = await ClientService.post(
          path: 'auth/authenticate', payload: loginPayload);

      print(loginResp);
      if (loginResp.statusCode == 200) {
        ClientService.token = loginResp.data['accessToken'];
        SharedData.save(jsonEncode(loginResp.data), 'authData');

        if (fieldValue['isThirdParty'] as bool) {
          var socialdata = [
            {
              "type": fieldValue['thirdPartyName'],
              "socialMediaId": fieldValue['thirdPartyId'],
              "imageFromSocialMedia": fieldValue['imageFromSocialMedia'],
              "socialMediaAvatar": fieldValue['imageFromSocialMedia']
            }
          ];
          resp.data['profile']['socialMediaOAuths'] = socialdata;
          var userPayload = resp.data['profile'];

          inspect(userPayload);
          var userUpdateResp = await ClientService.Put(
              path: 'user-profile',
              id: resp.data['profile']['_id'],
              payload: userPayload);
          print(userUpdateResp);
          if (userUpdateResp.statusCode == 200) {
            SharedData.save(jsonEncode(userUpdateResp.data), 'userData');
            SharedData.save(true.toString(), 'isLogin');
            return {
              "msg": "Account Created Successfully!!",
              "status": "success"
            };
          } else {
            return {"msg": "Something Went Wrong!!", "status": "error"};
          }
        } else {
          SharedData.save(true.toString(), 'isLogin');
          return {"msg": "Account Created Successfully!!", "status": "success"};
        }
      } else {
        return {"msg": "Something Went Wrong!!", "status": "error"};
      }
    } else {
      return {"msg": "Something Went Wrong!!", "status": "error"};
    }
  }

  LoginWithGoogle() async {
    loginWith.value = LoginType.googleToken;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    inspect(googleSignInAccount);
    if (googleSignInAccount != null) {
 
      fieldValue.value = {
        'fullName': googleSignInAccount.displayName ?? '',
        'email': googleSignInAccount.email,
        'thirdPartyId': googleSignInAccount.id,
        'imageFromSocialMedia': googleSignInAccount.photoUrl ?? '',
        'isThirdParty': true,
        'thirdPartyName': 'GOOGLE',
        'mobile': '',
        'password': '',
        'userName': '',
        'countryCode': ''
      };
      print('fieldValue$fieldValue');
      // return {"msg": "Please fill all field !!", "status": "success"};
      var respLogin = await login();
      return respLogin;
    } else {
      return {"msg": "Something Went Wrong!!", "status": "error"};
    }
  }

  dynamic signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    inspect(googleSignInAccount);
    if (googleSignInAccount != null) {
   
      var pw = generatePassword();
      fieldValue.value = {
        'fullName': googleSignInAccount.displayName ?? '',
        'email': googleSignInAccount.email,
        'thirdPartyId': googleSignInAccount.id,
        'imageFromSocialMedia': googleSignInAccount.photoUrl ?? '',
        'isThirdParty': true,
        'thirdPartyName': 'GOOGLE',
        'mobile': '',
        'password': pw,
        'userName': '',
        'countryCode': ''
      };
      print('fieldValue$fieldValue');
      print('pw${pw}');
      // return {"msg": "Please fill all field !!", "status": "success"};
      var respSignup = await signUp();
      return respSignup;
    } else {
      return {"msg": "Something Went Wrong!!", "status": "error"};
    }
  }

  dynamic signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: [
        'public_profile',
        'email',
        'pages_show_list',
        'pages_messaging',
        'pages_manage_metadata'
      ],
    );
    // final result = await facebookLogin.logInWithReadPermissions(['email']);

    if (result.status == LoginStatus.success) {
      // you are logged
      print(result);
      fieldValue.value = {
        'fullName': '',
        'email': '',
        'thirdPartyId': result.accessToken ?? '',
        'imageFromSocialMedia': '',
        'isThirdParty': true,
        'thirdPartyName': 'FACEBOOK',
        'mobile': '',
        'password': '',
        'userName': '',
        'countryCode': ''
      };
      final AccessToken accessToken = result.accessToken!;
      return {"msg": "Please fill all field !!", "status": "success"};
    } else {
      inspect(result);
      print('${result.message}');
      return {"msg": "Something Went Wrong!!", "status": "error"};
    }
  }

  void setFielsvalue(String text, String name) {
    fieldValue.value[name] = text;
    print(fieldValue);
  }

  String generatePassword({
    bool letter = true,
    bool isNumber = true,
    bool isSpecial = true,
  }) {
    final length = 20;
    final letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    final letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final number = '0123456789';
    final special = '@#%^*>\$@?/[]=+';

    String chars = "";
    if (letter) chars += '$letterLowerCase$letterUpperCase';
    if (isNumber) chars += '$number';
    if (isSpecial) chars += '$special';

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }
}
