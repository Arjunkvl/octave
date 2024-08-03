import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marshal/Presentation/Icons/icon_data.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/HomePageBloc/home_page_bloc.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/greetings%20cubit/greetings_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/helpers/sliver_for_sticky_top.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/body_list_view.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/recent_widget_at_top.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/top_tile.dart';
import 'package:marshal/Presentation/pages/Select%20Page/select_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<GreetingsCubit>().setGreeting();
    context.read<HomePageBloc>().add(GetRequiredData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    leadingWidth: 140.w,
                    backgroundColor: Colors.transparent,
                    actions: [
                      GestureDetector(
                        onTap: () {
                          goToSelectPage(context);
                        },
                        child: SvgPicture.asset(AppIcons.searchIcon),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      SvgPicture.asset(AppIcons.recentIcon),
                      SizedBox(
                        width: 20.w,
                      ),
                      SvgPicture.asset(AppIcons.settingsIcon),
                    ],
                    leading: BlocBuilder<GreetingsCubit, GreetingsState>(
                      builder: (context, state) {
                        return Text(
                          state.greeting,
                          style: Theme.of(context).textTheme.bodyLarge,
                        );
                      },
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: MySliverPersistentHeaderDelegate(
                      minHeight: 50.h,
                      maxHeight: 50.h,
                      child: const Column(
                        children: [
                          TopTile(),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 8.w,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: 4.15,
                        crossAxisCount: 2),
                    itemCount: 6,
                    itemBuilder: (context, index) => const RecentWidgetAtTop(),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Jump back in',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                  // const BodyListView(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Recently played',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                  // const BodyListView(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'New releases for you',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<HomePageBloc, HomePageState>(
                    builder: (context, state) {
                      if (state is HomePageLoaded) {
                        return BodyListView(
                          songs: state.songs,
                          coverUrlList: state.coverUrlList,
                        );
                      } else {
                        return const SliverToBoxAdapter(
                          child: SizedBox(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void goToSelectPage(context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const SelectPage(),
    ),
  );
}
