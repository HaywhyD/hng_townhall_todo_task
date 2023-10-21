import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/components/custom_text.dart';
import '../../common/components/dimension.dart';
import '../../common/components/loading_widget.dart';
import '../../common/constants/app_color.dart';
import '../../common/constants/route_constant.dart';
import '../../core/config/router_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      startImageSwitchTimer();
    });
  }

  Future<void> startImageSwitchTimer() async {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      routerConfig.pushReplacement(RoutesPath.homeScreen);
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 4.0,
                  left: 0.0,
                  child: CustomText(
                    requiredText: 'To-Do List',
                    color: AppColor.textColor.withOpacity(0.6),
                    fontSize: MyDimension.dim35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomText(
                  requiredText: 'To-Do List',
                  color: AppColor.appColor,
                  fontSize: MyDimension.dim35,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            10.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 55),
              child: CustomText(
                requiredText: 'Let\'s do this',
                color: AppColor.appColor.withOpacity(0.7),
                fontSize: MyDimension.dim22,
              ),
            ),
            10.verticalSpace,
            const LoadingWidget(),
          ],
        ),
      ),
    );
  }
}
