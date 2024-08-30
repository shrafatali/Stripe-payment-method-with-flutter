// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  Future makePayment({
    required String amount,
    required String currency,
  }) async {
    try {
      Map<String, dynamic>? paymentIntentData =
          await createPaymentIntent(amount, currency);

      print("paymentIntentData : $paymentIntentData");

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        style: ThemeMode.dark,
        merchantDisplayName: 'SAQ',
        customerId: paymentIntentData!['customer'],
        paymentIntentClientSecret: paymentIntentData['client_secret'],
        customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
      ));
      displayPaymentSheet();
    } catch (e, s) {
      if (kDebugMode) {
        print('exception:$e$s');
      }
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
          // parameters: PresentPaymentSheetParameters(
          //   clientSecret: paymentIntentData['client_secret'],
          //   confirmPayment: true,
          // ),
          );

      print('currency: PKR 1 ');

      Get.snackbar(
        'Payment',
        'Payment Successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
      );
    } on Exception catch (e) {
      if (e is StripeException) {
        if (kDebugMode) {
          print("Error from Stripe: ${e.error.localizedMessage}");
        }
      } else {
        if (kDebugMode) {
          print("Unforeseen error: ${e.toString()}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("exception:$e");
      }
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      String secrectKey = 'your secrect key';
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $secrectKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      if (kDebugMode) {
        print('err charging user: ${err.toString()}');
      }
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
