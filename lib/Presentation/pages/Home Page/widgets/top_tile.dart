import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/core/colors.dart';

class TopTile extends StatelessWidget {
  const TopTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: topTileColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        'Music',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
