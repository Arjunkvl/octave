import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/core/colors.dart';

class RecentWidgetAtTop extends StatelessWidget {
  const RecentWidgetAtTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 166.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: kbackGroundGrey,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('Assets/Images/cover.png'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3),
                bottomLeft: Radius.circular(3),
              ),
            ),
            width: 40.h,
            height: 40.h,
          ),
          SizedBox(
            width: 10.w,
          ),
          Flexible(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Perfect Hits",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
