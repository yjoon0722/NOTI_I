import 'dart:io';

import 'package:cashnote/client/TdiClient.dart';
import 'package:cashnote/routes/app_pages.dart';
import 'package:cashnote/routes/app_routes.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prefs/prefs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:advertising_id/advertising_id.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  /// ios 회원가입에 필요한 권한 / 안드로이드는 필요x
  if (Platform.isIOS) {
    await Permission.camera.request();
    await Permission.photos.request();
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Prefs.init();
    firebaseCloudMessaging_Listeners();
    if(Platform.isAndroid) {
      /// 기본값 false
      var isVisited = Prefs.getBoolF("isVisited");
      isVisited.then((bool isVisited) {
        if(!isVisited) {
          initReferrerDetails();
        }
      });
    }
  }

  @override
  void dispose() {
    Prefs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360,720),
      minTextAdapt: true,
      builder: () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.list
      ),
    );
  }

  /// fcm
  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    FirebaseMessaging.instance.getToken().then((token){
      print('token:'+token!);
    });

    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      print('getInitialMessage data: ${message?.data}');
    });

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage data: ${message.data}");
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp data: ${message.data}');
    });

  }

  /// ios fcm permission 설정
  void iOS_Permission() {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);

    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings)
    // {
    //   print("Settings registered: $settings");
    // });
  }

  /// 안드로이드 referrer
  Future<void> initReferrerDetails() async {
    String referrerDetailsString;
    try {
      ReferrerDetails referrerDetails = await AndroidPlayInstallReferrer.installReferrer;

      referrerDetailsString = referrerDetails.toString();

      print("referrerDetailsString : $referrerDetailsString");

      Dio dio = Dio();
      String secret_key = "1n33bxXvg2oDLr1uLNmvKKy8EAUk9TrBkbldIfx4cAVwJY5yOoI7Fc0TgNQEass25bzYJFDrRak76UNBQCYq3GmBAmY6o33V558Wn9jEtcEQNGabgiT4xgPvnPYAC";
      final client = TdiClient(dio);

      PackageInfo appInfo = await PackageInfo.fromPlatform();
      var app_version = appInfo.version;
      print("PackageInfo.fromPlatform().version = ${app_version}");

      try {
        var advertisingId = await AdvertisingId.id(true);
        print("advertisingId = $advertisingId");
        await client.postInstallRefererInfo(secret_key,
            InstallRefererInfoDto(
              referrer: referrerDetails.installReferrer,
              app_version: app_version,
              adid: advertisingId,
            )
        );
        print("referrerDetails.installReferrer: ${referrerDetails.installReferrer}");
      }catch (e) {
        print("adId error : $e");
      }
    } catch (e) {
      referrerDetailsString = 'Failed to get referrer details: $e';
      print(referrerDetailsString);
    }

    if (!mounted) return;
  }
}