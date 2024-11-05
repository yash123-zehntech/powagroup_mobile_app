import 'package:flutter/cupertino.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../../app/locator.dart';
import '../../../../../services/api.dart';
import '../../../../../util/constant.dart';

class DeleteAccountViewMode extends BaseViewModel {
  final navigationService = locator<NavigationService>();

  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String _email = '';

  Api apiCall = locator<Api>();

  String get email => _email;
  set email(String email) {
    _email = email;
    notifyListeners();
  }

  // on login buttion clik
  onSubmitButtonClick() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // callForgotPasswordApi();
    } else {}
  }
}

  //  send otp api calling
//   callForgotPasswordApi() async {
//     setBusy(true);
//     var map = Map<String, dynamic>();
//     map['email'] = emailController.text.toString();

//     ForgotPasswordResponse forgotPasswordResp =
//         await apiCall.userForgotPassword(map);

//     switch (forgotPasswordResp.statusCode) {
//       case Constants.sucessCode:
//         navigationService.pushNamedAndRemoveUntil(Routes.successView,
//             predicate: (route) => route.isFirst);

//         break;
//       case Constants.wrongError:
//         AppUtil.showDialogbox(AppUtil.getContext(),
//             forgotPasswordResp.error ?? 'Oops Something went wrong');

//         break;
//       case Constants.networkErroCode:
//         AppUtil.showDialogbox(AppUtil.getContext(),
//             forgotPasswordResp.error ?? 'Oops Something went wrong');

//         break;
//       default:
//         {
//           if (forgotPasswordResp.error != null &&
//               forgotPasswordResp.error!.isNotEmpty) {
//             AppUtil.showDialogbox(AppUtil.getContext(),
//                 forgotPasswordResp.error ?? 'Oops Something went wrong');
//           }
//         }
//         break;
//     }
//     setBusy(false);
//   }
// }
