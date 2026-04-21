class ApiConstants {
  static const String baseUrl = 'https://usta-d.dryfix.com.tr';
  static const String login = '$baseUrl/api/v1/auth/login';
  static const String register = '$baseUrl/api/v1/auth/register';
  static const String history = '$baseUrl/api/v1/history';
  static const String updatePassword = '$baseUrl/api/v1/profile/password';
  static const String updateProfile = '$baseUrl/api/v1/profile';
  static const String verifyQr = '$baseUrl/api/v1/qr/verify';
  static const String me = '$baseUrl/api/v1/me';
  static const String orders = '$baseUrl/api/v1/orders';
  static String orderDetail(int id) => '$orders/$id';
  static const String products = '$baseUrl/api/v1/products';
  static String productById(int id) => '$products/$id';
  static const String forgotPassword = '$baseUrl/api/v1/auth/forgot-password';
  static const String resetPassword = '$baseUrl/api/v1/auth/reset-password';
  static const String deactivate = '$baseUrl/api/v1/auth/deactivate';
  static const String addresses = '$baseUrl/api/v1/addresses';
  static String addressDetail(int id) => '$addresses/$id';
  static String addressesByType(String addressType) => '$addresses?address_type=$addressType';
  static String setAddressDefault(int id) => '$addresses/$id/default';
  static String cities({int limit = 81}) =>
      '$baseUrl/api/v1/cities?limit=$limit';
  static String districts(int cityId, {int limit = 200}) =>
      '$baseUrl/api/v1/districts?city_id=$cityId&limit=$limit';

  static const String notifications = '$baseUrl/api/v1/notifications';
  static String notificationDetail(int id) => '$notifications/$id';

  static const String mobileLogs = '$baseUrl/api/v1/mobile-logs';

  static const String supportMessages = '$baseUrl/api/v1/support-messages';
  static String supportMessageDetail(int id) => '$supportMessages/$id';

  static const String banners = '$baseUrl/api/v1/banners';
  static String bannerClick(int id) => '$banners/$id/click';

  static const String welcomeBonusClaim = '$baseUrl/api/v1/welcome-bonus/claim';

  static const String submitGameScore = '$baseUrl/api/v1/game/score';
  static const String finishMemoryMatch =
      '$baseUrl/api/v1/games/memory-match/finish';
}
