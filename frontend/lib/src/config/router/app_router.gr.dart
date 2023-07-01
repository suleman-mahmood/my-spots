// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    VideoPlayerRoute.name: (routeData) {
      final args = routeData.argsAs<VideoPlayerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: VideoPlayerView(
          key: args.key,
          videoPath: args.videoPath,
        ),
      );
    },
    WelcomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WelcomeView(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashView(),
      );
    },
    SignupRoute.name: (routeData) {
      final args = routeData.argsAs<SignupRouteArgs>(
          orElse: () => const SignupRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SignupView(key: args.key),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileView(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginView(key: args.key),
      );
    },
    ReelsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ReelsView(),
      );
    },
    FinalStepRoute.name: (routeData) {
      final args = routeData.argsAs<FinalStepRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FinalStepView(
          key: args.key,
          videoUrl: args.videoUrl,
          thumbnailUrl: args.thumbnailUrl,
        ),
      );
    },
    DashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardView(),
      );
    },
  };
}

/// generated route for
/// [VideoPlayerView]
class VideoPlayerRoute extends PageRouteInfo<VideoPlayerRouteArgs> {
  VideoPlayerRoute({
    Key? key,
    required String videoPath,
    List<PageRouteInfo>? children,
  }) : super(
          VideoPlayerRoute.name,
          args: VideoPlayerRouteArgs(
            key: key,
            videoPath: videoPath,
          ),
          initialChildren: children,
        );

  static const String name = 'VideoPlayerRoute';

  static const PageInfo<VideoPlayerRouteArgs> page =
      PageInfo<VideoPlayerRouteArgs>(name);
}

class VideoPlayerRouteArgs {
  const VideoPlayerRouteArgs({
    this.key,
    required this.videoPath,
  });

  final Key? key;

  final String videoPath;

  @override
  String toString() {
    return 'VideoPlayerRouteArgs{key: $key, videoPath: $videoPath}';
  }
}

/// generated route for
/// [WelcomeView]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute({List<PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashView]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignupView]
class SignupRoute extends PageRouteInfo<SignupRouteArgs> {
  SignupRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          SignupRoute.name,
          args: SignupRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static const PageInfo<SignupRouteArgs> page = PageInfo<SignupRouteArgs>(name);
}

class SignupRouteArgs {
  const SignupRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'SignupRouteArgs{key: $key}';
  }
}

/// generated route for
/// [ProfileView]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginView]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<LoginRouteArgs> page = PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key}';
  }
}

/// generated route for
/// [ReelsView]
class ReelsRoute extends PageRouteInfo<void> {
  const ReelsRoute({List<PageRouteInfo>? children})
      : super(
          ReelsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReelsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [FinalStepView]
class FinalStepRoute extends PageRouteInfo<FinalStepRouteArgs> {
  FinalStepRoute({
    Key? key,
    required String videoUrl,
    required String thumbnailUrl,
    List<PageRouteInfo>? children,
  }) : super(
          FinalStepRoute.name,
          args: FinalStepRouteArgs(
            key: key,
            videoUrl: videoUrl,
            thumbnailUrl: thumbnailUrl,
          ),
          initialChildren: children,
        );

  static const String name = 'FinalStepRoute';

  static const PageInfo<FinalStepRouteArgs> page =
      PageInfo<FinalStepRouteArgs>(name);
}

class FinalStepRouteArgs {
  const FinalStepRouteArgs({
    this.key,
    required this.videoUrl,
    required this.thumbnailUrl,
  });

  final Key? key;

  final String videoUrl;

  final String thumbnailUrl;

  @override
  String toString() {
    return 'FinalStepRouteArgs{key: $key, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl}';
  }
}

/// generated route for
/// [DashboardView]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
