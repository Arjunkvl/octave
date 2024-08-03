import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/search_select_bar.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/search_tile.dart';

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: false,
                pinned: false,
                backgroundColor: Colors.transparent,
                leadingWidth: 200,
                leading: Text(
                  'Search',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SearchSelectBar(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Browse all',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
              SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.w,
                    childAspectRatio: 1.63,
                    crossAxisCount: 2,
                  ),
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return const SearchTile();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
