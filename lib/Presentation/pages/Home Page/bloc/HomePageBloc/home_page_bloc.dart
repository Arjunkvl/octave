import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:marshal/Presentation/pages/Home%20Page/helpers/variables.dart';
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
      //getting required data for homepage;
      Option<List<Song>> result =
          await locator<GetNewReleseas>().call(lastSong: event.lastSong);
      result.fold(() async {
        emit(HomePageError());
      }, (result) async {
        sharedSongRepo.updateNewReleaseList(result);
      });
      emit(HomePageLoading());
      emit(HomePageLoaded(songs: sharedSongRepo.newReleaseList));
      isfetching = false;
    });
  }
}
