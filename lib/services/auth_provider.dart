// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:powagroup/model/user_model.dart';
// import 'package:powagroup/services/api_client.dart';
// import 'package:powagroup/services/api_methods.dart';
// import 'package:powagroup/ui/screen/modules/user_module/login/login_view_model.dart';
// import 'package:powagroup/ui/screen/modules/user_module/profile/profile_view_model.dart';

// enum Status {
//   NotLoggedIn,
//   NotRegistered,
//   LoggedIn,
//   Registered,
//   Authenticating,
//   Registering,
//   LoggedOut
// }

// class AuthProvider with ChangeNotifier {
//   Status _loggedInStatus = Status.NotLoggedIn;
//   final Status _registeredInStatus = Status.NotRegistered;
//   //User authUser = User();

//   Status get loggedInStatus => _loggedInStatus;
//   Status get registeredInStatus => _registeredInStatus;

//   Future<Map<String, dynamic>> login(String email, String password) async {
//     var result;

//     var map = Map<String, dynamic>();
//     map['email'] = 'chris@inspiredsoftware.com.au';
//     map['password'] = 'JhbGciOiJIUzI1';

//     // final Map<String, dynamic> loginData = {
//     //   'email': email,
//     //   'password': password
//     // };

//     _loggedInStatus = Status.Authenticating;
//     notifyListeners();

//     Response response = await post(
//       Uri.parse(ApiClient.BASE_URL + ApiMethods.userLogin),
//       body: map,
//       //headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(response.body);

//       var userData = responseData['token'];
//       ProfileViewModel viewModel = new ProfileViewModel();

//       viewModel.authUser = User.fromJson({'token': userData});

//       //UserPreferences().saveUser(authUser);

//       _loggedInStatus = Status.LoggedIn;
//       notifyListeners();

//       result = {'status': true, 'message': 'Successful', 'token': userData};
//     } else {
//       _loggedInStatus = Status.NotLoggedIn;
//       notifyListeners();
//       result = {
//         'status': false,
//         'message': json.decode(response.body)['error']
//       };
//     }
//     return result;
//   }

//   // Future<Map<String, dynamic>> register(String email, String password, String passwordConfirmation) async {

//   //   final Map<String, dynamic> registrationData = {
//   //     'user': {
//   //       'email': email,
//   //       'password': password,
//   //       'password_confirmation': passwordConfirmation
//   //     }
//   //   };

//   //   _registeredInStatus = Status.Registering;
//   //   notifyListeners();

//   //   return await post(AppUrl.register,
//   //       body: json.encode(registrationData),
//   //       headers: {'Content-Type': 'application/json'})
//   //       .then(onValue)
//   //       .catchError(onError);
//   // }

//   // static Future<FutureOr> onValue(Response response) async {
//   //   var result;
//   //   final Map<String, dynamic> responseData = json.decode(response.body);

//   //   if (response.statusCode == 200) {

//   //     var userData = responseData['data'];

//   //     User authUser = User.fromJson(userData);

//   //     UserPreferences().saveUser(authUser);
//   //     result = {
//   //       'status': true,
//   //       'message': 'Successfully registered',
//   //       'data': authUser
//   //     };
//   //   } else {

//   //     result = {
//   //       'status': false,
//   //       'message': 'Registration failed',
//   //       'data': responseData
//   //     };
//   //   }

//   //   return result;
//   // }

//   static onError(error) {
//     return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
//   }
// }
