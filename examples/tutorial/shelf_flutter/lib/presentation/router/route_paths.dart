abstract final class RoutePaths {
  static const books = '/books';
  static const shelves = '/shelves';
  static const shelfPattern = '/shelves/:shelfId';
  static const favourites = '/favourites';

  static String shelf(String id) => '/shelves/$id';
}
