import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';
import 'package:marshal/data/repository/User%20SetUp%20Repo/user_setup_repo_impl.dart';

class SetCloudSpace {
  final UserSetupRepoImpl repository;

  SetCloudSpace({required this.repository});
  Future<void> call() async {
    await repository.setCloudSpace();
  }
}

class AddPlayListToCloud {
  final UserSetupRepoImpl repository;
  AddPlayListToCloud({required this.repository});
  Future<void> call({required Playlist playList}) async {
    await repository.addPlayList(playList: playList);
  }
}

class RemovePlayListFromCloud {
  final UserSetupRepoImpl repository;
  RemovePlayListFromCloud({required this.repository});
  Future<void> call({required String title}) async {
    await repository.removePlayList(title: title);
  }
}

class GetPlayLists {
  final UserSetupRepoImpl repository;
  GetPlayLists({required this.repository});
  Future<List<Playlist>> call() async {
    return await repository.getPlayLists();
  }
}
