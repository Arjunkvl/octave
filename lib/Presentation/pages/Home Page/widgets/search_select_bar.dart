import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marshal/Presentation/Icons/icon_data.dart';
import 'package:marshal/Presentation/pages/Search%20Page/page/search_page.dart';
import 'package:marshal/Presentation/pages/Home%20Page/helpers/sliver_for_sticky_top.dart';

class SearchSelectBar extends StatelessWidget {
  const SearchSelectBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: MySliverPersistentHeaderDelegate(
        minHeight: 50.h,
        maxHeight: 50.h,
        child: GestureDetector(
          onTap: () => goToSearchPage(context),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            height: 55,
            width: 360.w,
            child: Row(
              children: [
                SizedBox(
                  width: 20.w,
                ),
                SvgPicture.asset(
                  AppIcons.searchBlackIcon,
                ),
                SizedBox(
                  width: 15.w,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('What do you want to listen to?',
                      style: Theme.of(context).textTheme.displayLarge),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void goToSearchPage(context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const SearchPage(),
    ),
  );
}
