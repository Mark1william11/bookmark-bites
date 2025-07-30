// This class holds all the route paths for the app.
class AppRoutes {
  AppRoutes._(); // This class is not meant to be instantiated.

  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static String recipeDetails(String id) => '/recipe/$id';
  static String category(String categoryName) => '/category/$categoryName';
}