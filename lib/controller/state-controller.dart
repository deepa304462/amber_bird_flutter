import 'dart:convert';

import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/data/user_profile/user_profile.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/services/firebase-cloud-message-sync-service.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var isLogin = false.obs;
  var currentTab = 0.obs;
  var activePageName = ''.obs;
  var onboardingDone = false.obs;
  var isActivate = false.obs;
  var isEmailVerified = false.obs;
  var isPhoneVerified = false.obs;
  var backButtonPress = 0.obs;
  RxString tokenManagerEntityId = ''.obs;
  RxList<ProductSummary> filteredProducts = <ProductSummary>[].obs;
  RxList<ProductSummary> cartProducts = <ProductSummary>[].obs;
  RxInt totalPrice = 0.obs;
  RxInt currentBottomNavItemIndex = 0.obs;
  RxInt productImageDefaultIndex = 0.obs;
  Rx<UserProfile> loggedInProfile = UserProfile().obs;

  @override
  void onInit() {
    backButtonPress.value = 0;
    getLoginInfo();
    changeTab(currentTab.toInt());
    super.onInit();
  }

  backPressed() {
    backButtonPress.value = backButtonPress.value + 1;
    if (backButtonPress.value < 2) {
      CodeHelp.toast('Press back on more time to exit');
    }
  }

  getLoginInfo() async {
    var onboardLocarl = await (SharedData.read('onboardingDone'));
    bool onboard = onboardLocarl.toString() == 'true';
    onboardingDone.value = onboard;
    var isLoginShared = await (SharedData.read('isLogin'));
    bool b = isLoginShared.toString() == 'true';
    isLogin.value = b;
    var authData = jsonDecode(await (SharedData.read('authData')));
    var userData = jsonDecode(await (SharedData.read('userData')));
    ClientService.token = authData['accessToken'] ?? '';
    if (userData['mappedTo'] != null) {
      syncUserProfile(userData['mappedTo']['_id']);
      isActivate.value = userData['authEmailVerified'];
      isEmailVerified.value = userData['authEmailVerified'];
      isPhoneVerified.value = userData['mobileVerified'];
    }
    // update token
    //end update token
    if (authData['tokenManagerEntityId'] != null) {
      tokenManagerEntityId.value = authData['tokenManagerEntityId'];
    }
  }

  getCustomerDetail(tokenManagerEntityId) async {
    var customerInsightDetail = await ClientService.post(
        path: 'customerInsight/detail',
        payload: {},
        payloadAsString: tokenManagerEntityId); 
    if (customerInsightDetail.statusCode == 200) {
      OfflineDBService.save(
          OfflineDBService.customerInsightDetail, customerInsightDetail.data);
    }
  }

  getCustomerData(tokenManagerEntityId) async {
    var customerInsight = await ClientService.get(
        path: 'customerInsight', id: tokenManagerEntityId);
    if (customerInsight.statusCode == 200) {
      OfflineDBService.save(
          OfflineDBService.customerInsight, customerInsight.data);
    }
  }

  resendMail() async {
    var resp = await ClientService.post(
        path:
            'profile-auth/resend/verificationEmail/${tokenManagerEntityId.value}',
        payload: {}); 
    if (resp.statusCode == 200) {
      return {"msg": "Mail sent Successfully!!", "status": "success"};
    } else {
      return {"msg": "Something Went Wrong!!", "status": "error"};
    }
  }

  logout() {
    OfflineDBService.delete(OfflineDBService.customerInsightDetail,
        OfflineDBService.customerInsightDetail);
    isLogin.value = false;
    isActivate.value = false;
    isEmailVerified.value = false;
    isPhoneVerified.value = false;
    ClientService.token = '';
    SharedData.save(false.toString(), 'isLogin');
    SharedData.remove('userData');
    SharedData.remove('authData');
    SharedData.remove('ProfileAuthData');
    SharedData.remove('ProfileAuthData');
    changeTab(currentTab.toInt());
  }

  bool isPriceOff(ProductSummary product) {
    if (product.varient!.price!.offerPrice != null) {
      return true;
    } else {
      return false;
    }
  }

  void calculateTotalPrice() {
    totalPrice.value = 0;
    for (var element in cartProducts) {
      if (isPriceOff(element)) {
        totalPrice.value += (element.varient!.price!.offerPrice!)
            as int; //element.quantity * element.off!;
      } else {
        totalPrice.value += element.varient!.price!.offerPrice
            as int; //element.quantity * element.price;
      }
    }
  }

  setCurrentTab(curTab) {
    currentTab.value = (curTab);
    changeTab(currentTab.toInt());
  }

  bool showSearch() { 
    if (activePageName.value == 'main' ||
        activePageName.value == 'category' ||
        activePageName.value == 'refer') {
      return true;
    } else {
      return false;
    }
  }

  navigateToUrl(url) {
    if (url == '/home/cart') {
      activePageName.value == 'cart';
      Modular.to.navigate('/home/cart');
    }
  }

  changeTab(currentTab) {
    switch (currentTab) {
      case 0:
        activePageName.value = 'main';
        Modular.to.navigate('/home/main');
        break;
      case 1:
        activePageName.value = 'category';
        Modular.to.navigate('/home/category');
        break;
      case 2:
        activePageName.value = 'refer';
        Modular.to.navigate('/home/refer');
        break;
      case 3:
        if (isLogin.value) {
          activePageName.value = 'profile';
          Modular.to.navigate('/home/profile');
        } else {
          activePageName.value = 'login';
          Modular.to.navigate('/home/login');
        }
        break;
    }
  }

  addToCart(product) {
    product.quantity++;
    cartProducts.add(product);
    calculateTotalPrice();
  }

  void switchBetweenProductImages(int index) {
    productImageDefaultIndex.value = index;
  }

  void checkAuth() {}

  void syncUserProfile(profileId) {
    ClientService.get(path: 'user-profile', id: profileId).then((value) {
      loggedInProfile.value = UserProfile.fromMap(value.data);
      Ref data = Ref.fromMap({
        '_id': loggedInProfile.value.id,
        'name': loggedInProfile.value.fullName
      });
      FCMSyncService.tokenSync(data);
      getCustomerData(loggedInProfile.value.id);
      getCustomerDetail(loggedInProfile.value.id);
    }).catchError((error) {
      logout();
    });
  }
}
