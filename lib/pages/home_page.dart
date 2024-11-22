import 'package:flutter/material.dart';
import 'package:stripe_demo/services/stripe_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stripe Demo"),
        centerTitle: false,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              overlayColor: Colors.blueGrey,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              )),
          onPressed: () {
            StripeService.instance.makePayments(context);
          },
          child: const Text(
            "Pay Here!",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
