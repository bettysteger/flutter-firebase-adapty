import 'package:flutter/material.dart';

final ThemeData style = basicTheme();

ThemeData basicTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith();
}

// Font Size Tokens
const EmojiTextSize = 56.0;
const H1TextSize = 48.0;
const H2TextSize = 36.0;
const H3TextSize = 24.0;
const B1TextSize = 16.0;
const B2TextSize = 10.0;
const S1TextSize = 14.0;
const S2TextSize = 10.0;

// Font Line Height Tokens
const H1LineHeight = 1.1;
const H2LineHeight = 1.1;
const H3LineHeight = 1.3;
const H4LineHeight = 1.2;
const B1LineHeight = 1.6;
const B2LineHeight = 1.6;
const S1LineHeight = 1.2;
const S2LineHeight = 1.6;

// Font Letter Spacing Tokens
const H1LetterSpacing = 0.8;
const H2LetterSpacing = 0.8;
const H3LetterSpacing = 0.8;
const H4LetterSpacing = 0.6;
const B1LetterSpacing = 0.6;
const B2LetterSpacing = 0.8;
const S1LetterSpacing = 0.9;
const S2LetterSpacing = 0.7;

// Font Families
const String HeadlineFontName = 'PlayfairDisplay';
const String BodyFontName = 'Raleway';

// Text Styles
const TextColorDark = Colors.black;
const TextColorLight = Colors.white;

const AppBarTextStyle = TextStyle(
  fontFamily: BodyFontName,
  fontWeight: FontWeight.w700,
  fontSize: S1TextSize,
  color: TextColorDark,
);

const TabBarTextStyle = TextStyle(
  fontFamily: BodyFontName,
  fontWeight: FontWeight.w700,
  fontSize: 8,
  letterSpacing: 0.8,
);

const TitleTextStyle = TextStyle(
  fontFamily: BodyFontName,
  fontWeight: FontWeight.w700,
  fontSize: H1TextSize,
  color: TextColorDark,
);

const EmojiTextStyle = TextStyle(
  fontSize: EmojiTextSize,
);

const Headline1TextStyle = TextStyle(
  fontFamily: HeadlineFontName,
  fontWeight: FontWeight.w400,
  fontSize: H1TextSize,
  color: TextColorDark,
  letterSpacing: H1LetterSpacing,
  height: H1LineHeight,
  fontFeatures: [
    FontFeature.enable('lnum'),
  ],
);

const Headline2TextStyle = TextStyle(
  fontFamily: HeadlineFontName,
  fontWeight: FontWeight.w400,
  fontSize: H2TextSize,
  color: TextColorDark,
  letterSpacing: H2LetterSpacing,
  height: H2LineHeight,
  fontFeatures: [
    FontFeature.enable('lnum'),
  ],
);

const Headline3TextStyle = TextStyle(
  fontFamily: HeadlineFontName,
  fontWeight: FontWeight.w700,
  fontSize: H3TextSize,
  color: Colors.black,
  letterSpacing: H3LetterSpacing,
  height: H3LineHeight,
  fontFeatures: [
    FontFeature.enable('lnum'),
  ],
);

const ButtonTextStyle = TextStyle(
  fontFamily: BodyFontName,
  fontWeight: FontWeight.w800,
  fontSize: S1TextSize,
  color: TextColorDark,
  letterSpacing: H4LetterSpacing,
  height: H4LineHeight,
  fontFeatures: [
    FontFeature.enable('lnum'),
  ],
);

const Body1TextStyle = TextStyle(
  fontFamily: BodyFontName,
  fontWeight: FontWeight.w500,
  fontSize: B1TextSize,
  color: TextColorDark,
  letterSpacing: B1LetterSpacing,
  height: B1LineHeight,
  fontFeatures: [
    FontFeature.enable('lnum'),
  ],
);

const Body1BoldTextStyle = TextStyle(
  fontFamily: BodyFontName,
  fontWeight: FontWeight.bold,
  fontSize: B1TextSize,
  color: TextColorDark,
  letterSpacing: B1LetterSpacing,
  height: B1LineHeight,
  fontFeatures: [
    FontFeature.enable('lnum'),
  ],
);

const Body2TextStyle = TextStyle(
  fontFamily: BodyFontName,
  fontWeight: FontWeight.w500,
  fontSize: B2TextSize,
  color: TextColorDark,
  letterSpacing: B2LetterSpacing,
  height: B2LineHeight,
  fontFeatures: [
    FontFeature.enable('lnum'),
  ],
);

const Subtitle1TextStyle = TextStyle(
  fontFamily: BodyFontName,
  fontWeight: FontWeight.w900,
  fontSize: S1TextSize,
  color: TextColorDark,
  letterSpacing: S1LetterSpacing,
  height: S1LineHeight,
  fontFeatures: [
    FontFeature.enable('lnum'),
  ],
);

const Subtitle1RegularTextStyle = TextStyle(
  fontFamily: BodyFontName,
  fontWeight: FontWeight.normal,
  fontSize: S1TextSize,
  color: TextColorDark,
  letterSpacing: S1LetterSpacing,
  height: S1LineHeight,
  fontFeatures: [
    FontFeature.enable('lnum'),
  ],
);

const Subtitle2TextStyle = TextStyle(
  fontFamily: BodyFontName,
  fontWeight: FontWeight.w900,
  fontSize: S2TextSize,
  color: Colors.black,
  letterSpacing: S2LetterSpacing,
  height: S2LineHeight,
  fontFeatures: [
    FontFeature.enable('lnum'),
  ],
);

// Colors
const Color PrimaryColor = Color(0xff1E3A8A);  // Dark Blue
const Color SecondaryColor = Color(0xffA7C7FF);  // Light Blue
const Color TertiaryColor = Color(0xff3B82F6);  // Medium Blue
const Color DarkGray = Color(0xff37333E);  // Keeping this as is for dark gray
const Color MediumGray = Color(0xff908C97);  // Keeping this as is for medium gray
const Color LightGray = Color(0xffCDC9D3);  // Keeping this as is for light gray
const Color ExtralightGray = Color(0xffF5F3F8);  // Keeping this as is for extra light gray
const Color NavGray = Color(0xff625D69);  // Keeping this as is for navigation gray

// Gradients
const Gradient PrimaryGradient = LinearGradient(
  colors: [Color(0xff3B82F6), Color(0xff1E3A8A)],  // Blue gradient
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const Gradient SecondaryGradient = LinearGradient(
  colors: [Color(0xffA7C7FF), Color(0xffE0F0FF)],  // Light blue gradient
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const Gradient TertiaryGradient = LinearGradient(
  colors: [Color(0xff60A5FA), Color(0xff2563EB)],  // Medium blue to darker blue gradient
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const Gradient DarkGradient = LinearGradient(
  colors: [Color(0xff0D1B2A), Color(0xff0A1929)],  // Dark blue gradient for deep tones
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Shadow Styles
const Color PrimaryShadowColor = Color(0x3000A9F4);  // Light blue shadow
const Color SecondaryShadowColor = Color(0x10A7C7FF);  // Light blue shadow
const Color BlackShadowColor = Color(0x25000000);  // Keeping this as is for black shadow
const Color TertiaryShadowColor = Color(0x503B82F6);  // Medium blue shadow

const BlurRadiusHuge = 100.0;
const BlurRadiusBig = 20.0;
const BlurRadiusMedium = 10.0;
const BlurRadiusSmall = 8.0;
const BlurOffsetBig = 16.0;
const BlurOffsetMedium = 10.0;
const BlurOffsetSmall = 4.0;

const BoxShadow ShadowBigPrimary = BoxShadow(
  color: PrimaryShadowColor,
  blurRadius: BlurRadiusBig,
  offset: Offset(0, BlurOffsetBig),
);

const BoxShadow ShadowMediumPrimary = BoxShadow(
  color: PrimaryShadowColor,
  blurRadius: BlurRadiusMedium,
  offset: Offset(0, BlurOffsetMedium),
);

const BoxShadow ShadowSmallPrimary = BoxShadow(
  color: PrimaryShadowColor,
  blurRadius: BlurRadiusSmall,
  offset: Offset(0, BlurOffsetSmall),
);

const BoxShadow ShadowBigSecondary = BoxShadow(
  color: SecondaryShadowColor,
  blurRadius: BlurRadiusBig,
  offset: Offset(0, BlurOffsetBig),
);

const BoxShadow ShadowSmallSecondary = BoxShadow(
  color: SecondaryShadowColor,
  blurRadius: BlurRadiusSmall,
  offset: Offset(0, BlurOffsetSmall),
);

const BoxShadow ShadowHugeBlack = BoxShadow(
  color: BlackShadowColor,
  blurRadius: BlurRadiusHuge,
  offset: Offset(0, BlurOffsetBig),
);

const BoxShadow ShadowBigBlack = BoxShadow(
  color: BlackShadowColor,
  blurRadius: BlurRadiusBig,
  offset: Offset(0, BlurOffsetBig),
);

const BoxShadow ShadowMediumBlack = BoxShadow(
  color: BlackShadowColor,
  blurRadius: BlurRadiusMedium,
  offset: Offset(0, BlurOffsetMedium),
);

const BoxShadow ShadowSmallBlack = BoxShadow(
  color: BlackShadowColor,
  blurRadius: BlurRadiusSmall,
  offset: Offset(0, BlurOffsetSmall),
);

const BoxShadow ShadowBigTertiary = BoxShadow(
  color: TertiaryShadowColor,
  blurRadius: BlurRadiusBig,
  offset: Offset(0, BlurOffsetBig),
);

// Corner Radius Tokens
const RadiusMax = 100.0;
const RadiusBig = 32.0;
const RadiusMedium = 20.0;
const RadiusSmall = 12.0;

// Spacing Tokens
const SpacingXXS = 4.0;
const SpacingXS = 12.0;
const SpacingS = 16.0;
const SpacingM = 28.0;
const SpacingL = 32.0;
const SpacingXL = 36.0;
const SpacingXXL = 40.0;
const SpacingHuge = 64.0;

// Animation Duration Tokens
const AnimationDurationXXS = 100; // Milliseconds

// Animation Curve Tokens
const AnimationCurveStandard = Curves.fastOutSlowIn;
