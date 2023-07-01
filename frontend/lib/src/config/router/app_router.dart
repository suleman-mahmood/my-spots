import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:myspots/src/presentation/views/create_reels_view.dart';
import 'package:myspots/src/presentation/views/final_step_view.dart';
import 'package:myspots/src/presentation/views/home_view.dart';
import 'package:myspots/src/presentation/views/login_view.dart';
import 'package:myspots/src/presentation/views/profile_view.dart';
import 'package:myspots/src/presentation/views/saved_view.dart';
import 'package:myspots/src/presentation/views/search_reels_view.dart';
import 'package:myspots/src/presentation/views/signup_view.dart';
import 'package:myspots/src/presentation/views/splash_view.dart';
import 'package:myspots/src/presentation/views/video_player_view.dart';
import 'package:myspots/src/presentation/views/reels_view.dart';
import 'package:myspots/src/presentation/views/welcome_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: WelcomeRoute.page, initial: true),
        CustomRoute(
          page: CreateReelsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute(
          page: HomeRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute(
          page: LoginRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute(
          page: ProfileRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute(
          page: SavedRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute(
          page: SearchReelsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute(
          page: SignupRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute(
          page: SplashRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute(
          page: VideoPlayerRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute(
          page: ReelsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute(
          page: FinalStepRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
      ];
}
