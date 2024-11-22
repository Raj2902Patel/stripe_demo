import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Successful')),
      body: Center(
        child: Text('Your payment was successful!'),
      ),
    );
  }
}
