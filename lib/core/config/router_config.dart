import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:to_do_app/presentation/category_to_do_screen/category_todo_screen.dart';

import '../../common/constants/route_constant.dart';
import '../../presentation/add_to_do_screen/add_to_do_screen.dart';
import '../../presentation/home_screen/home_screen.dart';
import '../../presentation/splash_screen/splash_screen.dart';
import '../../presentation/success_screen/success_screen.dart';

final GoRouter routerConfig = GoRouter(
    initialLocation: RoutesPath.splash,
    errorBuilder: (context, state) => const Placeholder(),
    routes: [
      GoRoute(
        path: RoutesPath.splash,
        pageBuilder: (context, state) => CupertinoPage<void>(
          child: const SplashScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
          path: RoutesPath.categoryScreen,
          pageBuilder: (context, state) {
            if (state.extra != null) {
              Map<String, dynamic> args = state.extra as Map<String, dynamic>;

              return CustomTransitionPage(
                  transitionDuration: const Duration(milliseconds: 500),
                  barrierDismissible: false,
                  key: state.pageKey,
                  child: CategoryToDoScreen(
                    category: args['category'],
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(curve: Curves.easeInOutCirc)
                          .animate(animation),
                      child: child,
                    );
                  });
            } else {
              return CustomTransitionPage(
                  transitionDuration: const Duration(milliseconds: 500),
                  barrierDismissible: false,
                  key: state.pageKey,
                  child: const CategoryToDoScreen(
                    category: '',
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(curve: Curves.easeInOutCirc)
                          .animate(animation),
                      child: child,
                    );
                  });
            }
          }),
      GoRoute(
          path: RoutesPath.homeScreen,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 500),
                barrierDismissible: false,
                key: state.pageKey,
                child: const HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      GoRoute(
          path: RoutesPath.addTodoScreen,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 500),
                barrierDismissible: false,
                key: state.pageKey,
                child: const AddTodoScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      GoRoute(
          path: RoutesPath.successScreen,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 500),
                barrierDismissible: false,
                key: state.pageKey,
                child: const SuccessScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
    ]);
