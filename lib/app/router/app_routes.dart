final class AppRoute {
  final String path;
  final String name;

  const AppRoute({required this.path, required this.name});
}

abstract final class AppRoutes {
  static const homePath = '/home';
  static const dictionaryPath = '/dictionary';
  static const profilePath = '/profile';
  static const loginPath = '/login';

  static const home = AppRoute(path: homePath, name: 'home');
  static const dictionary = AppRoute(path: dictionaryPath, name: 'dictionary');
  static const profile = AppRoute(path: profilePath, name: 'profile');
  static const login = AppRoute(path: loginPath, name: 'login');
}
