import 'package:go_router/go_router.dart';
import 'package:gyofu/pages/fish_convert_page.dart';
import 'package:gyofu/pages/regional_fish_list_page.dart';
import 'package:gyofu/pages/regional_fish_detail_page.dart';
import 'package:gyofu/pages/regional_fish_registration_page.dart';
import 'package:gyofu/pages/splash_page.dart';
import 'package:gyofu/second_page.dart';
import 'package:gyofu/app/main_scaffold.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    // スプラッシュ画面（ナビゲーションバーなし）
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    // メイン画面（ナビゲーションバーあり）
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const RegionalFishListPage(),
        ),
        GoRoute(
          path: '/fish-convert',
          builder: (context, state) => const FishConvertPage(),
        ),
        GoRoute(
          path: '/second',
          builder: (context, state) => const SecondPage(),
        ),
        GoRoute(
          path: '/regional-fish-detail/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return RegionalFishDetailPage(fishId: id);
          },
        ),
        GoRoute(
          path: '/regional-fish-edit',
          builder: (context, state) => const RegionalFishRegistrationPage(),
        ),
      ],
    ),
  ],
);
