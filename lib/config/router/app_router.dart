import 'package:go_router/go_router.dart';
import 'package:mapas_flutter/presentation/screens/screens.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/permissions',
    builder: (context, state) => const PermissionsScreen(),
  ),
  //Ubicaci+on
  GoRoute(
    path: '/location',
    builder: (context, state) => const LocationMapScreen(),
  ),
  GoRoute(
    path: '/map',
    builder: (context, state) => const MapScreen(),
  ),
  GoRoute(
    path: '/controlled',
    builder: (context, state) => const ControlledMapScreen(),
  ),
]);
