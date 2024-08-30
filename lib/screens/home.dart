import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stripe_with_flutter/utils/stripe_hepler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final paymentController = Get.put(PaymentController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Stripe Payment'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              String amountt = '5000';
              String currencyy = 'PKR';

              try {
                // await StripeService.initPayment(amount, currency);
                // await StripeService.presentPaymentSheet();
                print("Click Fpr pay");

                await paymentController.makePayment(
                    // context: context,
                    amount: amountt,
                    currency: currencyy);
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error : ${e.toString()}"),
                  ),
                );
              }
            },
            child: const Text("Pay 5000"),
          ),
        ],
      )),
    );
  }
}
