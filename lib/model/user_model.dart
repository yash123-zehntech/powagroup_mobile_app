class User {
  // int? userId;
  // String? name;
  // String? email;
  // String? phone;
  // String? type;
  String? token;
  //String? renewalToken;

  User({
   this.token});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        // userId: responseData['id'],
        // name: responseData['name'],
        // email: responseData['email'],
        // phone: responseData['phone'],
        // type: responseData['type'],
        token: responseData['token'],
        //renewalToken: responseData['renewal_token']
    );
  }
}