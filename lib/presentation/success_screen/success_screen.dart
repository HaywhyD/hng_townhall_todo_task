import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do_app/common/constants/assets_constants.dart';

import '../../common/components/custom_text.dart';
import '../../common/constants/route_constant.dart';
import '../../core/config/router_config.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Container(
      width: mediaQuery.width,
      height: mediaQuery.height,
      padding: const EdgeInsets.only(
        top: 100.50,
        left: 16,
        right: 16,
        bottom: 48,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 144.w,
                  height: 144.h,
                  child: SvgPicture.asset('${Assets.svgPath}/done.svg'),
                ),
                24.verticalSpace,
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      requiredText: 'To-do Added',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.black,
                    ),
                    SizedBox(height: 8),
                    CustomText(
                      requiredText: 'Successfully',
                      fontWeight: FontWeight.w500,
                      fontSize: 23,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
          210.verticalSpace,
          GestureDetector(
            onTap: () => routerConfig.pushReplacement(RoutesPath.homeScreen),
            child: Container(
              width: double.infinity,
              height: 56,
              padding:
                  const EdgeInsets.symmetric(horizontal: 125, vertical: 16),
              decoration: ShapeDecoration(
                color: const Color(0xFFFF8C22),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    requiredText: 'Close',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
