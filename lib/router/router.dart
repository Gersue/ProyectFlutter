import 'package:go_router/go_router.dart';

import '../screens/budget.dart';
import '../screens/home.dart';


GoRouter router() {
  return GoRouter(
    initialLocation: "/budget",
    routes: [
      GoRoute(
        path: '/budget',
        builder: (context, state) => const Budget(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const Home(capital: 0,),
      )
    ],
  );
}