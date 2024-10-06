import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Song%20Cubit/song_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/song_list_view_tile.dart';
import 'package:shimmer/shimmer.dart';

class BodyListView extends StatelessWidget {
  final List songIds;
  final String categoryName;

  const BodyListView({
    super.key,
    required this.songIds,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SongCubit()..fetchSongs(songIds: songIds),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryName,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: 15.h,
          ),
          SizedBox(
            height: 150.h,
            child: BlocBuilder<SongCubit, SongState>(
              builder: (context, state) {
                if (state is SongLoading) {
                  return Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 66, 64, 64),
                    highlightColor: const Color.fromARGB(255, 83, 81, 81),
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10.w,
                      ),
                      itemBuilder: (context, index) => Column(
                        children: [
                          Container(
                            width: 120.w,
                            height: 120.h,
                            decoration: const BoxDecoration(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            height: 5.h,
                            width: 120.w,
                            decoration: const BoxDecoration(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is SongLoaded) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      // if (!state.hasMore) return false;
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
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
                      itemBuilder: (context, index) => SongListViewTile(
                        song: state.songs[index],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
