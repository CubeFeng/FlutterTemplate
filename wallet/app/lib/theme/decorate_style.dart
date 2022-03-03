import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DecorateStyles {
  static BoxDecoration decoration = BoxDecoration(
    color: Colors.white, // 底色
    boxShadow: [
      BoxShadow(
          offset: const Offset(0, 3), //x,y轴
          color: const Color(0xFF000000).withOpacity(0.08), //阴影颜色
          blurRadius: 5.w //投影距
          ),
    ],
  );
  static BoxDecoration decoration15 = BoxDecoration(
    color: Colors.white, // 底色
    boxShadow: [
      BoxShadow(
          offset: const Offset(0, 3), //x,y轴
          color: const Color(0xFF000000).withOpacity(0.08), //阴影颜色
          blurRadius: 5.w //投影距
          ),
    ],
    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
  );

  // ignore: non_constant_identifier_names
  static BoxDecoration decoration15_line = BoxDecoration(
    color: Colors.white, // 底色
    boxShadow: [
      BoxShadow(
          offset: const Offset(0, 3), //x,y轴
          color: const Color(0xFF000000).withOpacity(0.08), //阴影颜色
          blurRadius: 5.w //投影距
          ),
    ],
    border: Border.all(color: const Color(0xFF2750EB), width: 1),
    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
  );
}
