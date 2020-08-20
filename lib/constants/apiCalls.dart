class APIService {
  static final String _api = "https://api.theonestop.co.in/api";

  // USERS
  static final String loginAPI = "$_api/users/login/";
  static final String loginMobile = "$_api/users/loginMobile/";
  static final String verifyOTP = "$_api/users/loginMobile/verifyOTP/";
  static final String registerAPI = "$_api/users/register/";
  static final String registerAddressAPI = "$_api/users/register/address/new";
  static final String forgotMailerAPI = "$_api/users/forgotPassword-mailer/";
  // shopping cart file - _getUserDetails function
  static final String getUserAPI = "$_api/users/";
  // storesList.dart - _fetchUserAddress function
  static final String getAddressAPI = "$_api/users/user-address/";

  // PRODUCTS
  static final String getBestSellersAPI = "$_api/products/all/bestsellers";

  // ORDERS
  // shopping cart file - _postOrderToServer function
  static final String ordersAPI = "$_api/orders/";

  // Firebase
  static final String setDeviceTokenInFirestore =
      "$_api/firestore/consumersettoken";

  // Payments
  static final String getRzpKeyAPI = "$_api/payments/rzp";

  // OTHERS
  // loading.dart - _sendReqToServer function
  static final String mainTokenAPI = "https://api.theonestop.co.in/token";
  static final String deliveriesAllowedAPI =
      "https://api.theonestop.co.in/api/deliveries/allowed";
}
