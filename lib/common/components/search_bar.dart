import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_color.dart';
import 'dimension.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      onTap: onTap,
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFD1CDCD),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      backgroundColor:
          MaterialStateProperty.all(Colors.white), // Background color
      padding: MaterialStateProperty.all(const EdgeInsets.all(12.0)),
      hintStyle: MaterialStateProperty.all(
        GoogleFonts.roboto(
          color: AppColor.textColor.withOpacity(0.5),
          fontSize: MyDimension.dim10,
        ),
      ),
      hintText: "Search for task, date, categories",
      leading: Image.asset(
        'assets/png/search.png',
        width: 16,
      ),
    );
  }
}
