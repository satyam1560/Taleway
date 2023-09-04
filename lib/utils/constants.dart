import 'package:flutter/material.dart';
import 'package:viewstories/enums/enums.dart';
import 'package:viewstories/models/report.dart';

const webScreenSize = 600;

const primaryColor = Color(0xff0a0816);

const List<Report> reports = [
  Report(
    reportPost: ReportPost.sexualContent,
    reportString: 'Sexual Content',
  ),
  Report(
    reportPost: ReportPost.falseInformation,
    reportString: 'False Information',
  ),
  Report(
    reportPost: ReportPost.hate,
    reportString: 'Hate Speech',
  ),
  Report(
    reportPost: ReportPost.bulling,
    reportString: 'Bulling',
  ),
  Report(
    reportPost: ReportPost.other,
    reportString: 'Other',
  )
];

const profilePlaceholderImg =
    'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

const String errorImage =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjMD6Pl7n4lSFFphlDlRz7o4ULYlNrAC9KJN4sfz9mRDDgU_FzGrA-DNgLL8keHh90KJg&usqp=CAU';

const String termsOfService = 'https://taleway-app.web.app/#/terms-of-service';

const String privacyPolicy = 'https://taleway-app.web.app/#privacy-policy';

const gradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.009, 0.2, 0.85, 1.0],
    colors: [
      Color(0xff413d59),
      primaryColor,
      primaryColor,
      Color(0xff413d59),
    ],
  ),
);

const shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
