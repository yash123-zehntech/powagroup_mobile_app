class ApiMethods {
  // User API
  String userLogin = '/api/mobile/login';
  String refreshToken = '/api/mobile/refreshauth';
  String userForgotPassword = '/api/mobile/forgot_password';
  String registerUser = "/api/mobile/registration/new";
  String submitRequestForRegister = "/api/mobile/registration/existing";

  // API with login token
  String getAllFavouriteProduct = "/api/mobile/products";
  String getQuotations = "/api/mobile/orders";
  String getSalesOrder = "/api/mobile/orders";
  String getSalesOrderDetails = "/api/mobile/order";
  String getDeliveryAddress = "/api/mobile/contacts/delivery";
  String getInvoiceAddress = "/api/mobile/contacts/invoice";
  String getContactAddress = "/api/mobile/contacts/contact";
  String getExtraInfo = "/api/mobile/contacts/site/";
  String getSiteContact = "/api/mobile/contacts/all";
  String getWarehouses = "/api/mobile/warehouses";
  String create = "/api/mobile/order/create";
  String confirmPayment = "/api/mobile/order";
  String getBlogSummary = "/api/mobile/blog_posts";
  String getBlogsDetails = "/api/mobile/blog_post";
  String getUserProfile = "/api/mobile/user_profile";
  //-------------------Base Url for api integration
  static const stripeAPiBaseUrl = "https://api.stripe.com/v1";

  // APIs without Login token
  String getProductCategories = "/api/mobile/category";
  String getProductSubSubCategories = "/api/mobile/subcategories";
  String customerReview = "/api/mobile/review/recent";
  String getNewProduct = "/api/mobile/products";
  String getProductByKey = "/api/mobile/products";
  String getProductByid = "/api/mobile/product";
  String commontSection = "/api/mobile/review";

  String getVideos = "/api/mobile/videos";
  String getProjects = "/api/mobile/projects";
  String getContentSlider = "/api/mobile/content_slider";

  // create Address API
  String createAddress = "/api/mobile/contact/create";
  String deleteAddress = "/api/mobile/contact";
  String cities = "/api/mobile/contacts/cities";
  String createSiteContact = "/api/mobile/site_contacts/create";
  String deliveryMethods = "/api/mobile/delivery_methods";
  String getOrderTotals = "/api/mobile/get_order_totals";
}
