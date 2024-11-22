import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;

  ErrorPage({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Failed')),
      body: Center(
        child: Text('Error: $errorMessage'),
      ),
    );
  }
}
