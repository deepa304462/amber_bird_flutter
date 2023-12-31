import 'dart:convert';
import 'dart:developer';

import 'package:amber_bird/controller/appbar-scroll-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/customer_insight/customer_insight.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/membership/membership.dart';
import 'package:amber_bird/data/profile/profile.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/data/showcase-key.dart';
import 'package:amber_bird/data/user_profile/user_profile.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/services/firebase-cloud-message-sync-service.dart';
import 'package:amber_bird/ui/element/analytics.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import '../helpers/controller-generator.dart';

class Controller extends GetxController {
  Map<String, ShowcaseKey> showKeyMap = Map();
  var isLogin = false.obs;
  var currentTab = 0.obs;
  var activePageName = ''.obs;
  var isActivate = false.obs;
  var isEmailVerified = false.obs;
  var isPhoneVerified = false.obs;
  var showLoader = false.obs;
  var backButtonPress = 0.obs;
  RxString tokenManagerEntityId = ''.obs;
  RxString loggedInPRofileId = ''.obs;
  RxString userType = ''.obs;

  RxList<ProductSummary> filteredProducts = <ProductSummary>[].obs;
  RxList<ProductSummary> cartProducts = <ProductSummary>[].obs;
  RxList<String> dealsProductsIdList = <String>[].obs;
  RxMap<String, Membership> membershipList = <String, Membership>{}.obs;
  RxInt totalPrice = 0.obs;
  RxInt currentBottomNavItemIndex = 0.obs;
  RxInt productImageDefaultIndex = 0.obs;
  Rx<UserProfile> loggedInProfile = UserProfile().obs;
  Rx<Customer> customerDetail = Customer().obs;
  RxString membershipIcon = ''.obs;
  Rx<CustomerInsight> customerInsight = CustomerInsight().obs;
  late final Mixpanel _mixpanel;

  @override
  void onInit() {
    _initMixpanel();
    showKeyMap['home'] = ShowcaseKey(
      key: GlobalKey(),
      desc: 'All starts from here',
      title: 'Home',
      descTextStyle: TextStyles.bodyFont,
      titleTextStyle: TextStyles.titleFont,
      targetPadding: const EdgeInsets.all(5),
      tooltipBackgroundColor: AppColors.commonBgColor,
      textColor: AppColors.black,
    );
    showKeyMap['category'] = ShowcaseKey(
        key: GlobalKey(),
        desc: 'Browse your favourite products',
        title: 'Category',
        titleTextStyle: TextStyles.titleFont,
        targetPadding: const EdgeInsets.all(5),
        tooltipBackgroundColor: AppColors.commonBgColor,
        textColor: AppColors.black,
        descTextStyle: TextStyles.bodyFont);
    showKeyMap['brand'] = ShowcaseKey(
        key: GlobalKey(),
        desc: 'Explore all brands',
        title: 'Brands',
        titleTextStyle: TextStyles.titleFont,
        descTextStyle: TextStyles.bodyFont);
    showKeyMap['cart'] = ShowcaseKey(
        key: GlobalKey(),
        desc: '',
        title: '',
        titleTextStyle: TextStyles.titleFont,
        descTextStyle: TextStyles.bodyFont);
    showKeyMap['profile'] = ShowcaseKey(
        key: GlobalKey(),
        desc: 'Access or create your profile',
        title: 'Checkout cart',
        titleTextStyle: TextStyles.titleFont,
        descTextStyle: TextStyles.bodyFont);
    showKeyMap['wishlist'] = ShowcaseKey(
        key: GlobalKey(),
        desc: 'Access your favourite products',
        title: 'Wishlist & favourite products',
        titleTextStyle: TextStyles.titleFont,
        descTextStyle: TextStyles.bodyFont);
    showKeyMap['refer'] = ShowcaseKey(
        key: GlobalKey(),
        desc: 'Earn coins, Refer and get 9 ${CodeHelp.euro}',
        title: 'Share',
        titleTextStyle: TextStyles.titleFont,
        descTextStyle: TextStyles.bodyFont);
    showKeyMap['coinWallet'] = ShowcaseKey(
        key: GlobalKey(),
        desc: 'Check your S-COIN wallet',
        title: 'S-Wallet',
        titleTextStyle: TextStyles.titleFont,
        descTextStyle: TextStyles.bodyFont);
    backButtonPress.value = 0;
    getLoginInfo();
    getMembershipData();
    changeTab(currentTab.toInt());
    Modular.to.addListener(() {
      Modular.to.navigateHistory.forEach((element) {
        if (element.name == '/home/brand') {
          currentTab.value = 2;
        }
        if (element.name == '/home/main') {
          currentTab.value = 0;
        }
        if (element.name == '/home/category') {
          currentTab.value = 1;
        }
        if (element.name == '/widget/cart') {
          currentTab.value = 3;
        }
        if (element.name == '/widget/profile') {
          currentTab.value = 4;
        }
      });
    });
    super.onInit();
  }

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }

  getMembershipData() async {
    var membershipInfo =
        await ClientService.post(path: 'membershipInfo/search', payload: {});
    if (membershipInfo.statusCode == 200) {
      List data = membershipInfo.data;
      data.sort(
        (a, b) => a['orderBy'].compareTo(b['orderBy']),
      );
      data.forEach(
        (elem) {
          Membership member = Membership.fromMap(elem);
          membershipList[member.id ?? ''] = member;
          if (member.id!.toLowerCase() == userType.value.toLowerCase()) {
            membershipIcon.value = member.imageId!;
          }
        },
      );
    }
  }

  getUserIsActive() async {
    if (!isActivate.value) {
      await checkAuth();
    }
    return isActivate.value;
  }

  checkAuth() async {
    var tokenResp =
        await ClientService.get(path: 'auth', id: tokenManagerEntityId.value);
    if (tokenResp.statusCode == 200) {
      var userData = tokenResp.data;
      if (userData['mappedTo'] != null) {
        isActivate.value = userData['authEmailVerified'];
        isEmailVerified.value = userData['authEmailVerified'];
        isPhoneVerified.value = userData['mobileVerified'];
      }
    }
    return null;
  }

  backPressed() {
    backButtonPress.value = backButtonPress.value + 1;
    if (backButtonPress.value < 2) {
      CodeHelp.toast('Press back on more time to exit');
    }
  }

  getLoginInfo() async {
    var isLoginShared = await (SharedData.read('isLogin'));
    bool b = isLoginShared.toString() == 'true';
    isLogin.value = b;
    var authData = jsonDecode((await (SharedData.read('authData'))) ?? '{}');
    var userData = jsonDecode((await (SharedData.read('userData'))) ?? '{}');
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
      Customer cust = Customer.fromMap(
          (jsonDecode(jsonEncode(customerInsightDetail.data)))
              as Map<String, dynamic>);
      customerDetail.value = cust;
      if (customerDetail.value.personalInfo != null) {
        userType.value = customerDetail.value.personalInfo!.membershipType!;
        callGetCategory();
        getMembershipData();
      }
      var cartController =
          ControllerGenerator.create(CartController(), tag: 'cartController');

      if (cust.cart != null) {
        cartController.fetchCart();
        // cartController.calculatedPayment.value =
        //     cust.cart!.payment != null ? cust.cart!.payment! : Payment();
        // cartController.orderId.value = cust.cart!.id ?? '';
        // for (var element in cust.cart!.products!) {
        //   cartController.cartProducts[element.ref!.id ?? ''] = element;
        // }
      }

      if (Get.isRegistered<WishlistController>()) {
        var waishlistController = Get.find<WishlistController>();
        Customer cust = Customer.fromMap(
            (jsonDecode(jsonEncode(customerInsightDetail.data)))
                as Map<String, dynamic>);
        if (cust.cart != null) {
          waishlistController.wishlistId.value = cust.wishList!.id ?? '';
          for (var element in cust.wishList!.favorites!) {
            waishlistController.wishlistProducts[element.ref!.id ?? ''] =
                element;
          }
        }
      }
    }
  }

  getCustomerData(tokenManagerEntityId) async {
    var customerInsightData = await ClientService.get(
        path: 'customerInsight', id: tokenManagerEntityId);
    if (customerInsightData.statusCode == 200) {
      OfflineDBService.save(
          OfflineDBService.customerInsight, customerInsightData.data);
      CustomerInsight cust = CustomerInsight.fromMap(
          customerInsightData.data as Map<String, dynamic>);
      customerInsight.value = cust;
      if (Get.isRegistered<LocationController>()) {
        LocationController locationController = Get.find();
        locationController.setLocation();
      }
      People people = _mixpanel.getPeople();

      _mixpanel.identify('${loggedInProfile.value.id}@profile');

//       _mixpanel.people.set('d3a0334f-c3d3-4025-aee0-9d21f9482a51@profile');
// _mixpanel.identify();
      people.set("name", cust.name);
      people.set("\$name", cust.name);
      people.set("email", cust.email);
      people.set("\$email", cust.email);
      people.set("scoins", cust.scoins);
      people.set("spoints", cust.spoints);
      people.set("id", cust.id);
      people.set("userFriendlyCustomerId", cust.userFriendlyCustomerId);
      people.set("customerTrackerRef", cust.customerTrackerRef);
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
      return {"msg": "Oops, Something went Wrong!!", "status": "error"};
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
    SharedData.remove('referredbyId');
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
        totalPrice.value += (element.varient!.price!.offerPrice!) as int;
      } else {
        totalPrice.value += element.varient!.price!.offerPrice as int;
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
    if (url == '/widget/cart') {
      activePageName.value == 'cart';
    } else if (url == '/home/main') {
      activePageName.value = 'main';
    } else if (url == '/home/brand') {
      activePageName.value = 'search';
    } else if (url == '/home/category') {
      activePageName.value = 'category';
    } else if (url == '/login') {
      activePageName.value = 'login';
    } else if (url == '/widget/account') {
      activePageName.value = 'account';
    }
    if (Get.isRegistered<AppbarScrollController>()) {
      var appbarScrollController = Get.find<AppbarScrollController>();
      appbarScrollController.navigateTo(url);
    }
    // Modular.to.navigate(url);
  }

  changeTab(currentTab) {
    switch (currentTab) {
      case 0:
        navigateToUrl('/home/main');
        break;
      case 2:
        navigateToUrl('/home/brand');
        break;
      case 1:
        navigateToUrl('/home/category');
        break;
      case 3:
        if (isLogin.value) {
          navigateToUrl('/widget/cart');
        } else {
          navigateToUrl('/widget/account');
        }
        break;
      case 4:
        navigateToUrl('/widget/account');
        break;
    }
  }

  void switchBetweenProductImages(int index) {
    productImageDefaultIndex.value = index;
  }

  void syncUserProfile(profileId) {
    ClientService.get(path: 'user-profile', id: profileId).then((value) {
      loggedInProfile.value = UserProfile.fromMap(value.data);
      OfflineDBService.save(OfflineDBService.userProfile, value.data);
      Ref data = Ref.fromMap({
        '_id': loggedInProfile.value.id,
        'name': loggedInProfile.value.fullName
      });
      FCMSyncService.tokenSync(data);
      loggedInPRofileId.value = loggedInProfile.value.id!;
      getCustomerData(loggedInProfile.value.id);
      getCustomerDetail(loggedInProfile.value.id);
    }).catchError((error) {
      logout();
    });
  }

  resetPassInit() async {
    var payload = {
      "username": loggedInProfile.value.userName,
      "mappedTo": loggedInProfile.value.id,
      "orgRefId": "sbazar",
      "shortCode": '',
      "authEmail": loggedInProfile.value.email,
      "authMobile": loggedInProfile.value.mobile
    };
    var tokenResp = await ClientService.post(
        path: 'auth/passwordResetInit', payload: payload);
    if (tokenResp.statusCode == 200) {
      return {"msg": "Mail sent Successfully!!", "status": "success"};
    } else {
      return {"msg": "Oops, Something went Wrong!!", "status": "error"};
    }
  }

  deleteAccount() async {
    var tokenResp =
        await ClientService.get(path: 'auth', id: tokenManagerEntityId.value);
    if (tokenResp.statusCode == 200) {
      Profile userData = Profile.fromMap(tokenResp.data);
      userData.enabled = false;
      // log(jsonEncode(tokenResp.data).toString());
      // log(jsonEncode(userData).toString());
      // log(jsonEncode(userData));
      // print(userData);
      // userData payload = {
      //   'customerRef': (jsonDecode(custRef.toJson())),
      //   'favorites': listProd,
      //   '_id': wishlistId.value,
      //   'metaData': (jsonDecode(cust.wishList!.metaData!.toJson())),
      // };
      var updateResp = await ClientService.Put(
          path: 'auth',
          id: tokenManagerEntityId.value ?? '',
          payload: jsonDecode(userData.toJson()));
      if (updateResp.statusCode == 200) {
        logout();
        return {"msg": "Deleted Successfully!!", "status": "success"};
      } else {
        return {"msg": "Oops, Something went Wrong!!", "status": "error"};
      }
    }
  }

  String getMemberShipText() {
    if (userType == 'No_Membership') {
      return "Newbie";
    }
    return userType.toString();
  }
}

void callGetCategory() {
  MegaMenuController megaMenuController = ControllerGenerator.create(
      MegaMenuController(),
      tag: 'megaMenuController');
  megaMenuController.getCategory();
}
