import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/services/firebase-cloud-message-sync-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    'username': '',
    'countryCode': '',
    'profileImageId': ''
  }.obs;
  var usernameValid = true.obs;
  var suggestedUsername = ''.obs;
  var loginWith = LoginType.emailPassword.obs;

  @override
  void onInit() {
    initializeFirebase();
    super.onInit();
  }

  setLoginWith(key) {
    loginWith.value = key;
  }

  checkValidityUsername() async {
    if (fieldValue['username'].toString().length > 2) {
      usernameValid.value = false;
      var resp = await ClientService.get(
          path: 'auth/usernameSuggest?username=${fieldValue['username']}');
      if (resp.statusCode == 200) {
        if (fieldValue['username'].toString() == resp.data['username']) {
          usernameValid.value = true;
        } else {
          usernameValid.value = false;
          suggestedUsername.value = resp.data['username'];
        }
      }
    }
  }

  initializeFirebase() async {
    await Firebase.initializeApp();
  }

  resetFieldValue() {
    fieldValue.value = {
      'fullName': '',
      'email': '',
      'thirdPartyId': '',
      'imageFromSocialMedia': '',
      'isThirdParty': false,
      'thirdPartyName': '',
      'mobile': '',
      'password': '',
      'username': '',
      'countryCode': '',
      'profileImageId': ''
    };
  }

  addInMarketInfo() async {
    var loginPayload = {
      "data": {"email": fieldValue['email']},
    };
    print(loginPayload);
    var loginResp =
        await ClientService.post(path: 'marketingData', payload: loginPayload);
    if (loginResp.statusCode == 200) {
      return {"msg": "Email added Successfully!!", "status": "success"};
    } else {
      return {"msg": 'Something went wrong!', "status": "error"};
    }
  }

  login() async {
    var loginPayload = {
      "password": fieldValue['password'],
      "userName": fieldValue['username'],
      // "appName": "DIAGO_TEAM_WEB_APP"
    };
    if (loginWith.value == LoginType.usernamePassword &&
        fieldValue['password'] != '' &&
        fieldValue['userName'] != '') {
      loginPayload = {
        "password": fieldValue['password'],
        "userName": fieldValue['username']
      };
    } else if (loginWith.value == LoginType.emailPassword &&
        fieldValue['password'] != '' &&
        fieldValue['email'] != '') {
      loginPayload = {
        "password": fieldValue['password'],
        "email": fieldValue['email']
      };
    } else if (loginWith.value == LoginType.mobilePassword &&
        fieldValue['password'] != '' &&
        fieldValue['mobile'] != '') {
      loginPayload = {
        "password": fieldValue['password'],
        "mobile":
            '${fieldValue['countryCode'].toString()}@${fieldValue['mobile'].toString()}'
      };
    } else if (loginWith.value == LoginType.googleToken &&
        fieldValue['thirdPartyId'] != '') {
      loginPayload = {
        "socialMediaId": fieldValue['thirdPartyId'].toString(),
        "appName": "DIAGO_TEAM_WEB_APP"
      };
    } else {
      return {"msg": "Please fill all Field", "status": "error"};
    }
    var loginResp = await ClientService.post(
        path: 'auth/authenticate', payload: loginPayload);
    if (loginResp.statusCode == 200) {
      ClientService.token = loginResp.data['accessToken'];
      SharedData.save(jsonEncode(loginResp.data), 'authData');

      if (loginResp.data['tokenManagerEntityId'] != null) {
        String tokenManagerEntityId = loginResp.data['tokenManagerEntityId'];
        var tokenResp = await ClientService.get(
            path: 'auth', id: '$tokenManagerEntityId?locale=en');
        if (tokenResp.statusCode == 200) {
          SharedData.save(jsonEncode(tokenResp.data), 'userData');
          SharedData.save(true.toString(), 'isLogin');
          FCMSyncService.subcribeTopic('all');
          return {"msg": "Login Successfully!!", "status": "success"};
        } else {
          return {"msg": "Something Went Wrong!!", "status": "error"};
        }
      }
    } else {
      return {"msg": loginResp.data['description'], "status": "error"};
    }
  }

  dynamic signUp() async {
    if (fieldValue['email'] != '') {
      var payload = {
        // "suggestedUsername": fieldValue['username'],
        "suggestedUsername": fieldValue['email'],
        "orgRef": {"name": "sbazar", "_id": "sbazar"},
        "email": fieldValue['email'],
        "mobile":
            '${fieldValue['countryCode'].toString()}-${fieldValue['mobile'].toString()}',
        "fullName": fieldValue['fullName'],
        "acls": ["user"],
        // "profileType": "DIAGO_APP_PROFILE",
        "password": fieldValue['password'],
        "profileType": "CUSTOMER",
        "orgShortCode": "",
        "profileIcon": fieldValue['profileImageId']
      };
      dev.log(jsonEncode(payload).toString());
      var resp =
          await ClientService.post(path: 'profile-auth', payload: payload);
      if (resp.statusCode == 200) {
        SharedData.save(jsonEncode(resp.data), 'ProfileAuthData');
        dev.log(jsonEncode(resp.data).toString());
        var loginPayload = {
          "password": fieldValue['password'],
          // "userName": fieldValue['username'],
          // "userName": resp.data['userName'],
          "email": fieldValue['email']
          // "userName": fieldValue['email'],
        };
        var loginResp = await ClientService.post(
            path: 'auth/authenticate', payload: loginPayload);
        dev.log(jsonEncode(loginPayload).toString());
        if (loginResp.statusCode == 200) {
          dev.log(jsonEncode(loginResp.data).toString());
          ClientService.token = loginResp.data['accessToken'];
          SharedData.save(jsonEncode(loginResp.data), 'authData');
          if (loginResp.data['tokenManagerEntityId'] != null) {
            String tokenManagerEntityId =
                loginResp.data['tokenManagerEntityId'];
            var tokenResp = await ClientService.get(
                path: 'auth', id: '$tokenManagerEntityId?locale=en');
            if (tokenResp.statusCode == 200) {
              SharedData.save(jsonEncode(tokenResp.data), 'userData');
            }
          }
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
            dev.inspect(userPayload);
            var userUpdateResp = await ClientService.Put(
                path: 'user-profile',
                id: resp.data['profile']['_id'],
                payload: userPayload);
            if (userUpdateResp.statusCode == 200) {
              SharedData.save(true.toString(), 'isLogin');
              FCMSyncService.subcribeTopic('all');
              return {
                "msg": "Account Created Successfully!!",
                "status": "success"
              };
            } else {
              return {"msg": "Something Went Wrong!!", "status": "error"};
            }
          } else {
            SharedData.save(true.toString(), 'isLogin');
            FCMSyncService.subcribeTopic('all');
            return {
              "msg": "Account Created Successfully!!",
              "status": "success"
            };
          }
        } else {
          return {"msg": "Something Went Wrong!!", "status": "error"};
        }
      } else {
        return {"msg": "Something Went Wrong!!", "status": "error"};
      }
    } else {
      return {"msg": "Please fill all field!!", "status": "error"};
    }
  }

  LoginWithGoogle() async {
    loginWith.value = LoginType.googleToken;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      // googleSignIn.signOut();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      dev.inspect(googleSignInAccount);
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
          'username': '',
          'countryCode': '',
          'profileImageId': ''
        };
        var respLogin = await login();
        return respLogin;
      } else {
        return {"msg": "Something Went Wrong!!", "status": "error"};
      }
    } catch (err) {
      return {"msg": "Something Went Wrong!!", "status": "error"};
    }
  }

  dynamic signInWithGoogle() async {
    // FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    // googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    dev.inspect(googleSignInAccount);
    if (googleSignInAccount != null) {
      // var pw = generatePassword();
      fieldValue.value = {
        'fullName': googleSignInAccount.displayName ?? '',
        'email': googleSignInAccount.email,
        'thirdPartyId': googleSignInAccount.id,
        'imageFromSocialMedia': googleSignInAccount.photoUrl ?? '',
        'isThirdParty': true,
        'thirdPartyName': 'GOOGLE',
        'mobile': '',
        'password': '',
        'username': '',
        'countryCode': '',
        'profileImageId': ''
      };
      return {"msg": "Please fill all field !!", "status": "success"};
      // var respSignup = await signUp();
      // return respSignup;
    } else {
      return {"msg": "Something Went Wrong!!", "status": "error"};
    }
  }

  dynamic signInWithFacebook() async {
    // final LoginResult result = await FacebookAuth.instance.login(
    //   permissions: [
    //     'public_profile',
    //     'email'
    //   ],
    // );
    // final LoginResult result = await FacebookAuth.instance.login(
    //   permissions: ['public_profile', 'email'],
    // );

    // ,
    //     'pages_show_list',
    //     'pages_messaging',
    //     'pages_manage_metadata'
    // final result = await facebookLogin.logInWithReadPermissions(['email']);

    // if (result.status == LoginStatus.success) {
    //   // you are logged
    //   print(result);
    //   fieldValue.value = {
    //     'fullName': '',
    //     'email': '',
    //     'thirdPartyId': result.accessToken ?? '',
    //     'imageFromSocialMedia': '',
    //     'isThirdParty': true,
    //     'thirdPartyName': 'FACEBOOK',
    //     'mobile': '',
    //     'password': '',
    //     'username': '',
    //     'countryCode': '',
    //     'profileImageId': ''
    //   };
    //   // final AccessToken accessToken = result.accessToken!;
    //   return {"msg": "Please fill all field !!", "status": "success"};
    // } else {
    //   dev.inspect(result);
    //   return {"msg": "Something Went Wrong!!", "status": "error"};
    // }
  }

  void setFielsvalue(String text, String name) {
    fieldValue[name] = text;
  }

  String generatePassword(
      {bool letter = true, bool isNumber = true, bool isSpecial = true}) {
    const length = 20;
    const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const number = '0123456789';
    const special = '@#%^*>\$@?/[]=+';
    String chars = "";
    if (letter) chars += '$letterLowerCase$letterUpperCase';
    if (isNumber) chars += number;
    if (isSpecial) chars += special;

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }

  resetPassInit() async {
    var payload = {
      // "username": fieldValue['username'],
      // "mappedTo": loggedInProfile.value.id,
      "orgRefId": "sbazar",
      "shortCode": '',
      "authEmail": fieldValue['email'],
      // "authMobile": loggedInProfile.value.mobile
    };
    var tokenResp = await ClientService.post(
        path: 'auth/passwordResetInit', payload: payload);
    if (tokenResp.statusCode == 200) {
      return {"msg": "Mail sent Successfully!!", "status": "success"};
    } else {
      return {"msg": "Mail is not registered!!", "status": "error"};
    }
  }

  editProfile() async {
    var userData = jsonDecode((await (SharedData.read('userData')) ?? '{}'));
    var userResp = await ClientService.get(
        path: 'user-profile', id: userData['mappedTo']['_id']);
    if (userResp.statusCode == 200) {
      var payload = userResp.data;
      if (!fieldValue['fullName'].isBlank!) {
        payload['fullName'] = fieldValue['fullName'];
      }
      if (!fieldValue['profileImageId'].isBlank!) {
        payload["profileIcon"] = fieldValue['profileImageId'];
      }
      var userUpdateResp = await ClientService.Put(
          path: 'user-profile',
          id: userData['mappedTo']['_id'],
          payload: payload);
      if (userUpdateResp.statusCode == 200) {
        return {"msg": "Profile saved successfully!!", "status": "success"};
      } else {
        return {"msg": "Something went wrong!!", "status": "error"};
      }
    } else {
      return {"msg": "Something went wrong!!", "status": "error"};
    }
  }
}
