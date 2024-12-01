import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/pages/Play%20List%20Page/helpers/cstm_sliver_deligate.dart';

class PlayListPage extends StatelessWidget {
  const PlayListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 70.h),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 256.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50)),
                      ),
                    ),
                    Positioned(
                      top: 80.h,
                      child: Container(
                        width: 250.w,
                        height: 250.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                'https://imgs.search.brave.com/iRRFBkIZ-g9aXcfMm24YoxkwHmrW7a6qkSDR_5XociE/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9pMS5z/bmRjZG4uY29tL2Fy/dHdvcmtzLTAwMDU3/MDE4ODQxNy03YWI4/a2otdDUwMHg1MDAu/anBn'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: PlayListPagePresistantDelegate(
                minHeight: 70,
                maxHeight: 120,
                child: SizedBox(
                  height: 100.h,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Liked Song',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          color: Colors.white,
                          Icons.play_circle,
                          size: 60,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverList.separated(
              separatorBuilder: (context, index) => SizedBox(
                height: 10.w,
              ),
              itemCount: 60,
              itemBuilder: (context, index) => Tilex(),
            )
          ],
        ),
      ),
    );
  }
}

class Tilex extends StatelessWidget {
  const Tilex({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 63.w,
          height: 63.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      'https://imgs.search.brave.com/iRRFBkIZ-g9aXcfMm24YoxkwHmrW7a6qkSDR_5XociE/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9pMS5z/bmRjZG4uY29tL2Fy/dHdvcmtzLTAwMDU3/MDE4ODQxNy03YWI4/a2otdDUwMHg1MDAu/anBn'))),
        ),
        SizedBox(
          width: 15.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 250,
              child: Text(
                overflow: TextOverflow.ellipsis,
                'Perfect',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              'Ed HEeer',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.remove_circle_outline,
              color: Colors.white,
            ))
      ],
    );
  }
}
