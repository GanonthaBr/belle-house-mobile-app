import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget buildErrorScreen(BuildContext context, String message) {
  return Scaffold(
    appBar: AppBar(title: Text('Error'), backgroundColor: Color(0xff61a1d6)),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Please try again or contact support.'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Go Back'),
          ),
        ],
      ),
    ),
  );
}
