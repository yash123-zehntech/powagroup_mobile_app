import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import 'package:powagroup/.env.example.dart';
import 'package:powagroup/util/util.dart';

import '../services/api_methods.dart';

class PaymentProvider {
  Map<String, dynamic>? paymentIntentData;

  PaymentProvider() {
    Stripe.publishableKey = stripePublishableKey;
  }
  Future<PaymentIntent?> makePayment(
      {required double amount, required String currency}) async {
    try {
      AppUtil.showCircularProgress(const Color.fromARGB(255, 102, 158, 236));
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        log(json.encode(paymentIntentData));
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                merchantDisplayName: 'Prospects',
                customerId: paymentIntentData!['customer'],
                setupIntentClientSecret: paymentIntentData!['client_secret'],
                paymentIntentClientSecret: paymentIntentData!['client_secret'],
                customerEphemeralKeySecret: paymentIntentData!['client_secret'],
                billingDetails: BillingDetails(
                    address: Address(
                        city: '',
                        country: 'AU',
                        line1: '',
                        line2: '',
                        postalCode: '',
                        state: ''))));
        AppUtil.showProgress(const Color.fromARGB(255, 102, 158, 236));
        await displayPaymentSheet();
        PaymentIntent _confirmedPaymentIntent = await Stripe.instance
            .retrievePaymentIntent(paymentIntentData!['client_secret']);

        return _confirmedPaymentIntent;
      } else {
        AppUtil.showSnackBar(
          'Could not initiate payment',
        );
      }
    } on Exception catch (e) {
      AppUtil.showCircularProgress(const Color.fromARGB(255, 102, 158, 236));
      if (e is StripeException) {
        AppUtil.showSnackBar(
          "${e.error.localizedMessage}",
        );
      } else {
        AppUtil.showSnackBar(
          e.toString(),
        );
      }
    } catch (e) {
      AppUtil.showSnackBar(
        e.toString(),
      );
    }
    return null;
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      rethrow;
    }
  }

  // fetchPaymentSheet() async {
  //   // payment-sheet
  //   Map<String, dynamic> body = {};
  //   var response = await http.post(
  //       Uri.parse('${AppUrl.stripeAPiBaseUrl}/payment-sheet'),
  //       body: body,
  //       headers: {
  //         'Authorization': 'Bearer $stripeSecretKey',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       });
  //   return jsonDecode(response.body);
  // }

  Future<Map<String, dynamic>> createPaymentIntent(
      double amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        // 'amount': amount.toString(),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('${ApiMethods.stripeAPiBaseUrl}/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      rethrow;
    }
  }

  calculateAmount(double amount) {
    // String formattedAmount = amount.toStringAsFixed(2);
    return (amount * 100).toInt().toString();
  }
  // calculateAmount(double amount) {
  //   final a = amount * 100;
  //   return a.toString();
  // }

  // formatDoubleAsInt(double value, {int decimalPlaces = 2}) {
  //   String stringValue = value.toString();
  //   int dotIndex = stringValue.indexOf('.');

  //   if (dotIndex != -1) {
  //     int endIndex = dotIndex + decimalPlaces + 1;
  //     if (endIndex < stringValue.length) {
  //       stringValue = stringValue.substring(0, endIndex);
  //     }
  //   }

  //   // Remove the decimal point and convert to integer

  //   return stringValue.replaceAll('.', '');
  // }
}
