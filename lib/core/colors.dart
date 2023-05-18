import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import '../locator.dart';

bool get isLightTheme => locator<SharedPrefService>().theme == 'light';

Color get kcPrimaryColor => isLightTheme ? kcDarkColor : kcLightColor;
Color get kcButtonIconColor => isLightTheme ? kcLightColor : kcDarkColor;
Color get kcCartItemBackgroundColor =>
    isLightTheme ? const Color(0xffF3F3F3) : const Color(0xff1F222A);

String get notFoundImage => isLightTheme ? 'light-not-found' : 'dark-not-found';

const Color kcLightColor = Color(0xffFDFDFD);
const Color kcDarkColor = Color(0xff181A20);

const Color kcLightSecondaryColor = Color(0xffE7E7E7);
const Color kcDarkSecondaryColor = Color(0xff35383F);

Color get kcSecondaryColor =>
    isLightTheme ? kcLightSecondaryColor : kcDarkSecondaryColor;
Color get kcIconColorSelected => isLightTheme ? kcDarkColor : kcLightColor;
Color get kcIconColor =>
    isLightTheme ? kcLightSubtitleTextColor : kcDarkSubtitleTextColor;

const Color kcLightHeadersColor = Color(0xFF000000);
const Color kcDarkHeadersColor = Color(0xffffffff);

const Color kcLightBodyTextColor = Color(0xff212121);
const Color kcDarkBodyTextColor = Color(0xffFAFAFA);

const Color kcLightSubtitleTextColor = Color(0xff616161);
const Color kcDarkSubtitleTextColor = Color(0xffE0E0E0);
//---------------------------------------------------------

const Color kcMediumGreyColorLightTheme = Color(0xffA6BCD0);
const Color kcMediumGreyColorDarkTheme = Color(0xff748A9D);
const Color kcLightGreyColor = Color(0xffe5e5e5);
const Color kcVeryLightGreyColor = Color(0xffF0F4F8);

const Color kcLightPrimaryColor = Color(0xffF2FFF1);
