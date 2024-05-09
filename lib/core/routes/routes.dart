import 'package:flutter_setup/layers/presentation/ui/pages/third_page.dart';
import 'package:go_router/go_router.dart';

import '../../global.dart';
import '../../pages/home/home.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return HomePage();
      },
      routes: <RouteBase>[
        // GoRoute(
        //   path: 'second_page',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const SecondPage();
        //   },
        // ),
        GoRoute(
          path: 'third_page',
          builder: (BuildContext context, GoRouterState state) {
            return const ThirdPage();
          },
        ),
      ],
    ),
  ],
);
