import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marshal/Presentation/Icons/icon_data.dart';
import 'package:marshal/Presentation/pages/Audio%20Upload%20Page/page/audio_upload_page.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/category%20Cubit/category_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Top%20Tile%20Cubit/top_tile_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/cubit/all_songs_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/greetings%20cubit/greetings_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/helpers/sliver_for_sticky_top.dart';
import 'package:marshal/Presentation/pages/Home%20Page/helpers/variables.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/body_list_view.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/recent_widget_at_top.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/song_list_view_tile.dart';
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
    context.read<AllSongsCubit>().getAllSongs();
    // context.read<RecentSongsCubit>().getRecentSongs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<TopTileCubit>().getSongsForTile();
    context.read<CategoryCubit>().fetchCategories();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.audio,
            allowMultiple: false,
          );

          if (result != null) {
            File audioFile = File(result.files.single.path!);
            if (context.mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AudioUploadPage(
                    audioFile: audioFile,
                  ),
                ),
              );
            }
          }
        },
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add),
      ),
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
                    // actions: [
                    //   GestureDetector(
                    //     onTap: () {
                    //       goToSelectPage(context);
                    //     },
                    //     child: SvgPicture.asset(AppIcons.searchIcon),
                    //   ),
                    //   SizedBox(
                    //     width: 20.w,
                    //   ),
                    //   SvgPicture.asset(AppIcons.recentIcon),
                    //   SizedBox(
                    //     width: 20.w,
                    //   ),
                    //   SvgPicture.asset(AppIcons.settingsIcon),
                    // ],
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                        return const SliverToBoxAdapter(
                            child: SizedBox.shrink());
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
                          'All Realeses',
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
                      height: 150.h,
                      child: BlocBuilder<AllSongsCubit, AllSongsState>(
                        builder: (context, state) {
                          if (state is AllSongsLoaded) {
                            return NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                // if (!state.hasMore) return false;
                                if (scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent &&
                                    !isAllSongFetching) {
                                  isAllSongFetching = true;
                                  context.read<AllSongsCubit>().getAllSongs();
                                  return true;
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
                                itemBuilder: (context, index) =>
                                    SongListViewTile(
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
                                    height: 200.h,
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
                      ],
                    ),
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
