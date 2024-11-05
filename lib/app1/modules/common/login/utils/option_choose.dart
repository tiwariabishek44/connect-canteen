import 'package:connect_canteen/app1/modules/common/logoin_option/login_option_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OptionChoose extends StatelessWidget {
  final loginOptionController = Get.put(LoginOptionController());

  // UI Constants
  static const _UIConfig = _OptionUIConfig(
    colors: _OptionColors(
      activeBackground: Color(0xFFFF4B5C), // Primary Red
      inactiveBackground: Color(0xFFF5F5F5), // Light Gray
      activeText: Colors.white,
      inactiveText: Color(0xFF2D2D2D), // Dark Gray
    ),
    dimensions: _OptionDimensions(
      borderRadius: 30.0,
      fontSize: 16.0,
      spacing: 3.0,
      height: 45.0,
    ),
    options: _OptionItems(
      canteen: 'As Canteen',
      helper: 'As Helper',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildOptionSelector());
  }

  Widget _buildOptionSelector() {
    if (loginOptionController.userTypes.value == 'student') {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: _UIConfig.dimensions.height,
      child: Row(
        children: [
          _buildOptionTile(
            label: _UIConfig.options.canteen,
            value: 'canteen',
          ),
          SizedBox(width: _UIConfig.dimensions.spacing.w),
          _buildOptionTile(
            label: _UIConfig.options.helper,
            value: 'canteenHelper',
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Obx(
        () => _OptionTile(
          label: label,
          isSelected: loginOptionController.userTypes.value == value,
          onTap: () => _handleSelection(value),
          config: _UIConfig,
        ),
      ),
    );
  }

  void _handleSelection(String value) {
    loginOptionController.userTypes.value = value;
  }
}

// Modular Option Tile Widget
class _OptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final _OptionUIConfig config;

  const _OptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(config.dimensions.borderRadius),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? config.colors.activeBackground
                : config.colors.inactiveBackground,
            borderRadius: BorderRadius.circular(config.dimensions.borderRadius),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: config.colors.activeBackground.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? config.colors.activeText
                    : config.colors.inactiveText,
                fontSize: config.dimensions.fontSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Configuration Classes
class _OptionUIConfig {
  final _OptionColors colors;
  final _OptionDimensions dimensions;
  final _OptionItems options;

  const _OptionUIConfig({
    required this.colors,
    required this.dimensions,
    required this.options,
  });
}

class _OptionColors {
  final Color activeBackground;
  final Color inactiveBackground;
  final Color activeText;
  final Color inactiveText;

  const _OptionColors({
    required this.activeBackground,
    required this.inactiveBackground,
    required this.activeText,
    required this.inactiveText,
  });
}

class _OptionDimensions {
  final double borderRadius;
  final double fontSize;
  final double spacing;
  final double height;

  const _OptionDimensions({
    required this.borderRadius,
    required this.fontSize,
    required this.spacing,
    required this.height,
  });
}

class _OptionItems {
  final String canteen;
  final String helper;

  const _OptionItems({
    required this.canteen,
    required this.helper,
  });
}
