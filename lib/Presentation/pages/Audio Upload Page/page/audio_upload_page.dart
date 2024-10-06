import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:marshal/Presentation/pages/Audio%20Upload%20Page/bloc/audio_upload_bloc.dart';

class AudioUploadPage extends StatelessWidget {
  final File audioFile;
  const AudioUploadPage({super.key, required this.audioFile});

  @override
  Widget build(BuildContext context) {
    context
        .read<AudioUploadBloc>()
        .add(ExtractMetadataEvent(audioFile: audioFile));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<AudioUploadBloc, AudioUploadState>(
        builder: (context, state) {
          if (state is AudioUploadInitial) {
            return const Center(
              child: Text('Extracting'),
            );
          }
          if (state is UploadCompletedState) {
            return Center(
                child: Text(
              'Upload Completed \nNow You Can Go Back',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ));
          }
          if (state is Uploading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Gap(5.h),
                  Text(
                    'Uploading please wait...\nDo not exit',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          }
          if (state is UploadErrorState) {
            return const Center(
              child: Text('FileAlreadyUploaded!'),
            );
          }
          if (state is UploadeState) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.memory(
                      Uint8List.fromList(state.tag.pictures.first.imageData),
                      width: 150,
                    ),
                    Gap(30.h),
                    RichText(
                      text: TextSpan(
                        text: "Title: ",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'cir',
                        ),
                        children: [
                          TextSpan(
                              text: state.tag.title,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Author: ",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'cir',
                        ),
                        children: [
                          TextSpan(
                              text: state.tag.artist,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Album: ",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'cir',
                        ),
                        children: [
                          TextSpan(
                              text: state.tag.album ?? 'Unknown',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    Gap(120.h),
                    GestureDetector(
                      onTap: () {
                        context.read<AudioUploadBloc>().add(UploadAudioEvent(
                            audioFile: audioFile, tag: state.tag));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.white,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(10.w),
                            content: const Text("Upload In Progress"),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        width: 100.w,
                        height: 30.h,
                        child: const Center(child: Text('Upload')),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
