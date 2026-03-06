import 'package:ailiotte/core/routes/app_pages.dart';
import 'package:ailiotte/core/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );

  await Hive.initFlutter();
  await Hive.openBox('notes');
  await Hive.openBox('syncQueue');

  runApp(const AiLiottie());
}

class AiLiottie extends StatelessWidget {
  const AiLiottie({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Offline Notes",

          initialRoute: AppRoutes.splashScreen,

          getPages: AppPages.routes,

          /// Default theme (optional but good practice)
          theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
        );
      },
    );
  }
}
