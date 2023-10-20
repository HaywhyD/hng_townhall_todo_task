import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String requiredText;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final bool softWrap;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const CustomText({
    Key? key,
    required this.requiredText,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textDecoration,
    this.softWrap = true,
    this.maxLines,
    this.textAlign, this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      requiredText,
      style: GoogleFonts.roboto(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      softWrap: softWrap,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
