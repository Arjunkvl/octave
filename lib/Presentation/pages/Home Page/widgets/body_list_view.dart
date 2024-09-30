// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:marshal/Presentation/pages/Home%20Page/widgets/song_list_view_tile.dart';
// import 'package:marshal/data/models/song_model.dart';

// class BodyListView extends StatelessWidget {
//   final List<Song> songs;

//   const BodyListView({
//     super.key,
//     required this.songs,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: SizedBox(
//         height: 200,
//         child: NotificationListener<ScrollNotification>(
//           onNotification: (ScrollNotification scrollInfo) {
//             if (!state.hasMore) return false;
//             if (scrollInfo.metrics.pixels ==
//                 scrollInfo.metrics.maxScrollExtent) {
//               context
//                   .read<PostBloc>()
//                   .add(FetchPosts(lastDocument: state.posts.last));
//             }
//             return false;
//           },
//           child: ListView.separated(
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             itemCount: songs.length,
//             separatorBuilder: (context, index) => SizedBox(
//               width: 10.w,
//             ),
//             itemBuilder: (context, index) => SongListViewTile(
//               song: songs[index],
//               index: index,
//               coverUrl: songs[index].coverUrl,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
