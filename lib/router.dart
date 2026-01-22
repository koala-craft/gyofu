import 'package:go_router/go_router.dart';
import 'package:gyofu/pages/fish_convert_page.dart';
import 'package:gyofu/second_page.dart';
import 'package:gyofu/app/main_scaffold.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const FishConvertPage(),
        ),
        GoRoute(
          path: '/second',
          builder: (context, state) => const SecondPage(),
        ),
      ],
    ),
  ],
);
