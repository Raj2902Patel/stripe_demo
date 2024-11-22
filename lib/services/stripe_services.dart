import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_demo/consts/consts.dart';
import 'package:stripe_demo/pages/error_page.dart';
import 'package:stripe_demo/pages/success_page.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayments(BuildContext context) async {
    try {
      // Log payment intent creation
      print("Creating payment intent...");
      String? paymentIntentClientSecret = await _createPaymentIntent(10, "usd");

      if (paymentIntentClientSecret == null) {
        throw Exception("Failed to create Payment Intent");
      }

      print("Initializing Payment Sheet...");
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Neel Patel",
        ),
      );

      print("Processing payment...");
      await _processPayment(context); // Pass context here
    } catch (error) {
      print("Error during payment: $error");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorPage(errorMessage: error.toString()),
        ),
      );
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecreteKey",
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Payment Intent created successfully: ${response.data}");
        return response.data['client_secret'];
      }
      print("Failed to create Payment Intent");
      return null;
    } catch (error) {
      print("Error creating Payment Intent: $error");
      return null;
    }
  }

  Future<void> _processPayment(BuildContext context) async {
    try {
      // Present payment sheet to user
      await Stripe.instance.presentPaymentSheet();

      // Confirm payment
      await Stripe.instance.confirmPaymentSheetPayment();

      print("Payment successful!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessPage()),
      );
    } on StripeException catch (stripeError) {
      print("StripeException occurred: $stripeError");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ErrorPage(errorMessage: "stripeError.error.localizedMessage"),
        ),
      );
    } catch (error) {
      print("Unknown error during payment: $error");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorPage(errorMessage: error.toString()),
        ),
      );
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100; // Convert to smallest currency unit
    return calculatedAmount.toString();
  }
}
