import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationDialog extends StatelessWidget {
  final String heading;
  final String subheading;
  final String confirmButton;
  final String cancelButton;
  final VoidCallback onConfirm;
  final bool showButtons;
  final Color? color;

  const ConfirmationDialog({
    Key? key,
    required this.heading,
    required this.subheading,
    required this.showButtons,
    required this.confirmButton,
    required this.cancelButton,
    required this.onConfirm,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Container(
          constraints: BoxConstraints(maxWidth: 85.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(theme),
              _buildContent(theme),
              if (showButtons) _buildActions(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (color ?? theme.colorScheme.error).withOpacity(0.1),
                  (color ?? theme.colorScheme.error).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              heading.toLowerCase() == 'logout'
                  ? Icons.logout_rounded
                  : Icons.warning_rounded,
              color: color ?? theme.colorScheme.error,
              size: 32,
            ),
          ),
          SizedBox(height: 16),
          Text(
            heading,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        subheading,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[600],
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildActions(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Confirm Button
          ElevatedButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? theme.colorScheme.error,
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: Size(double.infinity, 48),
            ).copyWith(
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (heading.toLowerCase() == 'logout')
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.logout_rounded, size: 20),
                  ),
                Text(
                  confirmButton,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          // Cancel Button
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: Size(double.infinity, 48),
            ).copyWith(
              overlayColor: MaterialStateProperty.all(
                Colors.grey.withOpacity(0.1),
              ),
            ),
            child: Text(
              cancelButton,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Modern Dialog Helper
void showModernDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  VoidCallback? onConfirm,
  Color? color,
  bool isDanger = false,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        heading: title,
        subheading: message,
        confirmButton: confirmText ?? 'Confirm',
        cancelButton: cancelText ?? 'Cancel',
        showButtons: true,
        onConfirm: onConfirm ?? () {},
        color: isDanger ? Colors.red : color,
      );
    },
  );
}

// Usage Example:
void showLogoutConfirmation(BuildContext context) {
  showModernDialog(
    context: context,
    title: 'Logout',
    message:
        'Are you sure you want to logout from your account? You\'ll need to sign in again to access your account.',
    confirmText: 'Logout',
    cancelText: 'Cancel',
    isDanger: true,
    onConfirm: () {
      // Handle logout logic
    },
  );
}
