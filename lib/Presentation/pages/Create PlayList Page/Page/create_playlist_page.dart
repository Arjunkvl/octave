import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';

import '../../Library page/bloc/Library Bloc/library_bloc.dart';

class CreatePlayList extends StatefulWidget {
  const CreatePlayList({
    super.key,
  });

  @override
  State<CreatePlayList> createState() => _CreatePlayListState();
}

class _CreatePlayListState extends State<CreatePlayList> {
  late TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Create A PlayList',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(
              height: 50.h,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: textEditingController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title',
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            MaterialButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              onPressed: () {
                context.read<LibraryBloc>().add(
                      AddPlayListEvent(
                        playlist: Playlist(
                          title: textEditingController.value.text,
                          cover: '',
                          songs: [],
                        ),
                      ),
                    );
                context.read<LibraryBloc>().add(GetPlayListsEvent());
                Navigator.pop(context);
              },
              child: Text(
                'Create',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          ],
        ),
      ),
    );
  }
}
