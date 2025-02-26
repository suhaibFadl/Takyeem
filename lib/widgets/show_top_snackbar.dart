import 'package:flutter/material.dart';

void showTopSnackBar(BuildContext context, String message) {
  final snackBar = CustomSnackBar(message: message);

  // Show the custom SnackBar using the Overlay
  showOverlay(context, snackBar);
}

void showOverlay(BuildContext context, Widget snackBar) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50, // Adjust the position from the top
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: snackBar,
      ),
    ),
  );

  // Insert the overlay entry into the overlay
  overlay.insert(overlayEntry);

  // Remove the overlay after a delay (for example, 3 seconds)
  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

class CustomSnackBar extends StatelessWidget {
  final String message;

  CustomSnackBar({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
