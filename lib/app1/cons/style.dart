import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppStyles {
  static TextStyle get appbar {
    return GoogleFonts.lato(
        textStyle: TextStyle(
            fontSize: 19.sp, fontWeight: FontWeight.w800, color: Colors.black));
  }

  static TextStyle get titleStyle {
    return GoogleFonts.lato(
        textStyle: TextStyle(
            fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.black));
  }

  static TextStyle get subtitleStyle {
    return GoogleFonts.poppins(
        textStyle: const TextStyle(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w500,
    ));
  }

  static TextStyle get listTileTitle {
    return GoogleFonts.poppins(
        fontSize: 15.5.sp,
        textStyle: const TextStyle(
          color: AppColors.iconColors,
          fontWeight: FontWeight.w600,
        ));
  }

  static TextStyle get subDetail {
    return AppStyles.listTilesubTitle.copyWith(
      fontFamily: 'Roboto',
      fontSize: 15.sp,
      color: Colors.grey.shade600,
    );
  }

  static TextStyle get listTilesubTitle {
    return GoogleFonts.poppins(
        fontSize: 15.sp,
        textStyle: const TextStyle(
          // color: Color.fromARGB(255, 107, 109, 110),
          color: Colors.grey,

          fontWeight: FontWeight.w500,
        ));
  }

  static TextStyle get topicsHeading {
    return GoogleFonts.lato(
        textStyle: TextStyle(
      fontSize: 18.sp,
      color: AppColors.iconColors,
      fontWeight: FontWeight.w800,
    ));
  }

  static TextStyle get subTopics {
    return GoogleFonts.lato(
        textStyle: TextStyle(
      fontSize: 15.sp,
      color: AppColors.secondaryColor,
      fontWeight: FontWeight.w600,
    ));
  }

  static TextStyle get tabItemTextStyle {
    return TextStyle(
      fontSize: 18.sp,
    );
  }
}

class AppPadding {
  static EdgeInsetsGeometry get screenHorizontalPadding {
    return EdgeInsets.symmetric(horizontal: 3.w);
  }
}
