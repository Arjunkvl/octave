import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/category%20Cubit/category_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Top%20Tile%20Cubit/top_tile_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/All%20Song/all_songs_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/greetings%20cubit/greetings_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/helpers/sliver_for_sticky_top.dart';
import 'package:marshal/Presentation/pages/Home%20Page/helpers/variables.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/body_list_view.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/recent_widget_at_top.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/song_list_view_tile.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/top_tile.dart';
import 'package:marshal/application/Services/Spotify/spotify_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<GreetingsCubit>().setGreeting();
    context.read<AllSongsCubit>().getAllSongs();
    context.read<TopTileCubit>().getSongsForTile();
    context.read<CategoryCubit>().fetchCategories();

    super.initState();
  }

  int page = 1;
  @override
  Widget build(BuildContext context) {
    SpotifyService().fetchSpotifyApiToken();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: false,
                leadingWidth: 200.w,
                backgroundColor: Colors.transparent,
                actions: [
                  // SizedBox(
                  //   width: 20.w,
                  // ),
                  // SvgPicture.asset(AppIcons.recentIcon),
                  // SizedBox(
                  //   width: 20.w,
                  // ),
                  // SvgPicture.asset(AppIcons.settingsIcon),
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
              BlocBuilder<TopTileCubit, TopTileState>(
                builder: (context, state) {
                  if (state is TopTileLoading) {
                    return SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 8.w,
                          crossAxisSpacing: 8.w,
                          childAspectRatio: 4.15,
                          crossAxisCount: 2),
                      itemCount: 6,
                      itemBuilder: (context, index) => Container(
                        width: 166.w,
                        height: 40.h,
                        decoration: const BoxDecoration(color: Colors.grey),
                      ),
                    );
                  }
                  if (state is TopTileLoaded) {
                    return SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 8.w,
                          crossAxisSpacing: 8.w,
                          childAspectRatio: 4.15,
                          crossAxisCount: 2),
                      itemCount: 6,
                      itemBuilder: (context, index) => RecentWidgetAtTop(
                        song: state.songs[index],
                      ),
                    );
                  } else {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }
                },
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20.h,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Taps',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 160.h,
                  child: BlocBuilder<AllSongsCubit, AllSongsState>(
                    builder: (context, state) {
                      if (state is AllSongsLoaded) {
                        return NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent &&
                                !isfetching) {
                              isfetching = true;
                              context
                                  .read<AllSongsCubit>()
                                  .getAllSongs(page: ++page);
                            }
                            return false;
                          },
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.songs.length,
                            separatorBuilder: (context, index) => SizedBox(
                              width: 10.w,
                            ),
                            itemBuilder: (context, index) => SongListViewTile(
                              song: state.songs[index],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20.h,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    BlocBuilder<CategoryCubit, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoaded) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.category.length,
                            itemBuilder: (context, index) => SizedBox(
                                height: 220.h,
                                child: BodyListView(
                                  songIds: state.category[index].songIds,
                                  categoryName: state.category[index].name,
                                )),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
