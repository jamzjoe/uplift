import 'package:flutter/material.dart';

class LoadingSnackbar {
  static void showLoadingSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16.0),
            Text("Posting your prayer intentions..."),
          ],
        ),

        duration:
            Duration(seconds: 5), // Adjust the duration as per your requirement
      ),
    );
  }
}
