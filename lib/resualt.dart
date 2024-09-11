import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  final String result; // Declare the result variable here

  const Result({super.key, required this.result}); // Use 'this.result' in the constructor

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.result), // Access the result from the widget
      ),
    );
  }
}
