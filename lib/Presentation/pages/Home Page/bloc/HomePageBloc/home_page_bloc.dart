import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/data/repository/song_repo_impl.dart';
import 'package:marshal/domain/Usecases/usecases.dart';
import 'package:marshal/domain/repository/shared_song_repo.dart';
import 'package:marshal/domain/repository/shared_url_repo.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final repository = SongRepoImpl();
  final SharedSongRepo sharedSongRepo;
  final SharedUrlRepo sharedUrlRepo;
  HomePageBloc({required this.sharedUrlRepo, required this.sharedSongRepo})
      : super(HomePageLoading()) {
    on<GetRequiredData>((event, emit) async {
      Option<dynamic> result = await locator<GetNewReleseas>().call();
      result.fold(() async {
        emit(HomePageError());
      }, (result) {
        sharedSongRepo.updateNewReleaseList(result);
        add(DataAccuredEvent());
      });
    });
    on<DataAccuredEvent>(
      (event, emit) async {
        sharedUrlRepo.coverUrlList =
            await locator<GenerateCoverUrls>().call(sharedSongRepo);
        sharedUrlRepo.songUrlList =
            await locator<GenerateSongUrls>().call(sharedSongRepo);
        emit(HomePageLoaded(
            songs: sharedSongRepo.getSongList(),
            coverUrlList: sharedUrlRepo.coverUrlList));
      },
    );
  }
}
