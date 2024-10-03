import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:marshal/Presentation/Icons/icon_data.dart';
import 'package:marshal/Presentation/pages/Audio%20Upload%20Page/page/audio_upload_page.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/HomePageBloc/home_page_bloc.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Recent%20Songs%20Cubit/recent_songs_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/greetings%20cubit/greetings_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/helpers/sliver_for_sticky_top.dart';
import 'package:marshal/Presentation/pages/Home%20Page/helpers/variables.dart';
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
    context.read<RecentSongsCubit>().getRecentSongs();
    context.read<HomePageBloc>().add(GetRequiredData(lastSong: ''));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    actions: [
                      GestureDetector(
                        onTap: () {
                          goToSelectPage(context);
                        },
                        child: GestureDetector(
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                            },
                            child: SvgPicture.asset(AppIcons.searchIcon)),
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
                    child: SizedBox(
                      height: 20.h,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 0,
                          itemBuilder: (context, index) => Container(
                              height: 200,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Text('data'),
                                    Text('data'),
                                    Text('data'),
                                  ])),
                        ),
                      ],
                    ),
                  )
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
