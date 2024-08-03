import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 163.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Positioned(
            left: 130,
            top: 40,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Transform.rotate(
                angle: 19 * (pi / 180),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 70.w,
                  height: 70.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
