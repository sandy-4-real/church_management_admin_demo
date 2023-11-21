import 'dart:math';

import 'package:church_management_admin/views/login_view.dart';
import 'package:church_management_admin/views/tabs/about_us_tab.dart';
import 'package:church_management_admin/views/tabs/demo.dart';
import 'package:church_management_admin/views/tabs/home_view.dart';
import 'package:church_management_admin/views/tabs/messages_tab.dart';
import 'package:church_management_admin/views/tabs/settings_tab.dart';
import 'package:church_management_admin/views/tabs/terms_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'models/church_details_model.dart';
import 'models/verses_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var delegate = await LocalizationDelegate.create(
    basePath: 'assets/i18n/',
      fallbackLocale: 'en_US',
      supportedLocales: ['ta','te','ml','kn','en_US','bn','hi','es','pt','fr','nl','de','it','sv','mr','gu','or',]);
  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  User? user = FirebaseAuth.instance.currentUser;

  ///Call this function while changing database
  initialFunction() {
    String roleDocId = generateRandomString(16);
    FirebaseFirestore.instance.collection("RolePermissions").doc(roleDocId).set({
      "id" : roleDocId,
      "role" : "Admin@gmail.com",
      "permissions" : [],
      "dashboardItems" : [],
    });

    FirebaseFirestore.instance.collection("Funds").doc('x18zE9lNxDto7AXHlXDA').set({
      "currentBalance" : 0,
      "totalCollect" : 00,
      "totalSpend" : 0,
    });

    String annDocId = generateRandomString(16);
    FirebaseFirestore.instance.collection("AnniversaryWishTemplates").doc(annDocId).set({
      "content" : "Many more happy return of the day",
      "id" : annDocId,
      "selected" : false,
      "title" : "Happy Anniversary",
      "withName" : true,
    });

    String birDocId = generateRandomString(16);
    FirebaseFirestore.instance.collection("BirthdayWishTemplates").doc(birDocId).set({
      "content" : "Many more happy return of the day",
      "id" : birDocId,
      "selected" : false,
      "title" : "Happy Anniversary",
      "withName" : true,
    });

    String churchDocId = generateRandomString(16);
    ChurchDetailsModel church = ChurchDetailsModel(
      phone: '',
      name: '',
      id: churchDocId,
      aboutChurch: [],
      area: '',
      buildingNo: '',
      city: '',
      familyIdPrefix: '',
      memberIdPrefix: '',
      logo: '',
      pincode: '',
      verseForToday: VerseTodayModel(
        text: '',
        date: '',
      ),
      roles: [
        RoleUserModel(
          roleName: "admin@gmail.com",
          rolePassword: "admin@1234",
        )
      ],
      state: '',
      streetName: '',
      website: '',
    );

    var churchJson = church.toJson();

    FirebaseFirestore.instance.collection("ChurchDetails").doc(churchDocId).set(churchJson);



    for(int v = 0; v < versesList.length; v++){
      String docId = generateRandomString(16);
      FirebaseFirestore.instance.collection("BibleVerses").doc(docId).set({
        "id" : docId,
        "text" : versesList[v].text,
        "verse" : versesList[v].verse,
      });
    }

  }

  /// 1. Connect with Firebase
  /// 2. Enable email/password authentication.
  /// 3. Add User with below credentials
  ///      username : admin@gmail.com
  ///      password: admin@1234
  ///
  /// 4. Run the initial function.
  /// 5. Run the app
  /// 6. Edit Church details in settings page
  /// 7. Enable Firebase Storage.
  /// 8. Enable Firebase Cloud messaging.
  /// 9. Copy the server api key from cloud messaging tab in firebase and copy to apiKeyForNotification in constants.dart
  /// 10. Enable {Trigger Email from Firestore} Extension from firebase extensions.


  // @override
  // void initState() {
  //   initialFunction();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: 'Church Management Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
        ),
        home: user != null ? HomeView(currentRole: user!.email!) : const LoginView(),
        //home: TermsPage(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
      ),
    );
  }

  static String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

}
///