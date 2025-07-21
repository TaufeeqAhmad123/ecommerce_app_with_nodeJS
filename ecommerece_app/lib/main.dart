
import 'package:device_preview/device_preview.dart';
import 'package:ecommerece_app/app/bindings/home_binding.dart';
import 'package:ecommerece_app/app/data/constants/app_theme.dart';
import 'package:ecommerece_app/app/modules/splash/splash_view.dart';
import 'package:ecommerece_app/app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(
    DevicePreview(
      enabled: false, // Set to true to enable Device Preview
      builder: (context) => MultiProvider(
        
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: const Main()),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: GetMaterialApp(
            title: 'Ngamar',
            debugShowCheckedModeBanner: false,
            useInheritedMediaQuery: true,
           // locale: DevicePreview.locale(context),
            //builder: DevicePreview.appBuilder,
            scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
            defaultTransition: Transition.fadeIn,
            theme: AppTheme.lightTheme,
            initialBinding: HomeBinding(),
            home: const SplashView(),
          ),
        );
      },
    );
  }
}
