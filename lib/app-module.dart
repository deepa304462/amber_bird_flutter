import 'dart:developer';

import 'package:amber_bird/home-page-module.dart';
import 'package:amber_bird/ui/pages/wild-card-route-page.dart';
import 'package:amber_bird/ui/pages/email-verification-page.dart';
import 'package:amber_bird/ui/pages/splash-offer-page.dart';
import 'package:flutter_modular/flutter_modular.dart';

//http://localhost:64123/#/form/60e6b312c7f5dc000df40a1c/en
class AppModule extends Module {
  // Provide a list of dependencies to inject into your project
  @override
  List<Bind> get binds => [];

  // Provide all the routes for your module
  @override
  List<ModularRoute> get routes => [
        // ChildRoute('/', child: (_, args) => LoginPageWidget()),
        ChildRoute('/splash', child: (_, args) => SplashOfferPage()),
        ChildRoute('/verify', child: (_, args) {
          return EmailVerificationPage(
              args.queryParams['email']!, args.queryParams['token']!);
        }),
        ModuleRoute('/', module: HomePageModule()),
        WildcardRoute(child: (context, args) {
          return WildCardRoutePage(args.uri);
        }),

        // ChildRoute('/feedbackFormList',
        //     child: (_, args) => FeedbackListWidget(),
        //     guards: [AppCommonGuard()]),
        // ChildRoute('/form',
        //     child: (_, args) => FormUiWidget(form: args.data),
        //     guards: [AppCommonGuard()]),
        // ChildRoute('/formWithUserAnswers',
        //     child: (_, args) => FormUiWidget(
        //           form: args.data['form'],
        //           userAnswers: args.data['userAnswers'],
        //         ),
        //     guards: [AppCommonGuard()]),
        // ChildRoute('/pateints-for-feedback',
        //     child: (_, args) => PatientForFeedbackPage(args.data),
        //     guards: [AppCommonGuard()]),
        // ChildRoute('/form/:formId/:lang',
        //     child: (_, args) => FormUiWidget(
        //           formId: args.params['formId'],
        //           lang: args.params['lang'],
        //         )),
        // ChildRoute('/findPatient',
        //     child: (_, args) => PatientFinderPageWidget(),
        //     guards: [AppCommonGuard()]),
        // ChildRoute('/login', child: (_, args) => LoginPage()),
      ];
}
