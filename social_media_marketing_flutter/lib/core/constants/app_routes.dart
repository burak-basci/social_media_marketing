/// Application route names
class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  // Authentication routes
  static const String login = '/login';
  static const String register = '/register';

  // Main app routes
  static const String dashboard = '/';
  static const String campaign = '/campaign';
  static const String calendar = '/calendar';
  static const String posts = '/posts';
  static const String connections = '/connections';
  static const String settings = '/settings';
  static const String logs = '/logs';

  // Sub-routes
  static const String postDetail = '/posts/:id';
  static const String campaignNew = '/campaign/new';
  static const String campaignEdit = '/campaign/:id/edit';
}
