class APIService {
  static final String _api = "https://frozen-sands-29962.herokuapp.com/api";

  // USERS
  static final String loginAPI = "$_api/users/login/";
  static final String registerAPI = "$_api/users/register/";
  static final String registerAddressAPI = "$_api/users/register/address/";
  static final String forgotMailerAPI = "$_api/users/forgotPassword-mailer/";
  // shopping cart file - _getUserDetails function
  static final String getUserAPI = "$_api/users/";

  // BUSINESSES
  // storesList.dart - _fetchStores function
  static final String businessListAPI = "$_api/businesses/user-access/";
  // storeProductList.dart - _fetchProductsFromStore function
  static final String businessProductsListAPI = "$_api/businesses/";

  // ORDERS
  // shopping cart file - _postOrderToServer function
  static final String ordersAPI = "$_api/orders/";

  // OTHERS
  // loading.dart - _sendReqToServer function
  static final String mainTokenAPI = "https://frozen-sands-29962.herokuapp.com/token";
}