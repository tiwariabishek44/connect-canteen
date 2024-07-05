import 'package:flutter/material.dart';

class CustomSnackBarContent extends StatefulWidget {
  final String message;
  final IconData icon;

  CustomSnackBarContent({required this.message, required this.icon});

  @override
  _CustomSnackBarContentState createState() => _CustomSnackBarContentState();
}

class _CustomSnackBarContentState extends State<CustomSnackBarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                value: _controller.value,
                strokeWidth: 2,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
            Icon(widget.icon, color: Colors.white, size: 16),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(widget.message, style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
