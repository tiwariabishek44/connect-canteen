import 'package:flutter/material.dart';

class PaymentSuccessPopup extends StatelessWidget {
  final String message;

  PaymentSuccessPopup({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tick icon on the left side
            Icon(
              Icons.check,
              color: Colors.green,
              size: 30,
            ),
            SizedBox(width: 20),
            // Success message on the right side
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
