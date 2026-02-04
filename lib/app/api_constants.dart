class ApiConstants {
  static const String baseUrl = 'https://dry-qr.getsmarty.dev';
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
  static const String deactivate = '$baseUrl/api/v1/auth/deactivate';
}
