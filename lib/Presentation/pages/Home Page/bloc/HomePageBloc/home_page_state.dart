part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageLoading extends HomePageState {}

class HomePageError extends HomePageState {}

@JsonSerializable()
class HomePageLoaded extends HomePageState {
  final List<Song> songs;

  HomePageLoaded({required this.songs});

  @override
  List<Object> get props => [songs];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'songs': songs.map((x) => x.toMap()).toList(),
    };
  }

  HomePageLoaded copyWith({List<Song>? songs}) {
    return HomePageLoaded(songs: songs ?? this.songs);
  }

  factory HomePageLoaded.fromMap(Map<String, dynamic> map) {
    return HomePageLoaded(
      songs: List<Song>.from(
        (map['songs'] as List<int>).map<Song>(
          (x) => Song.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory HomePageLoaded.fromJson(String source) =>
      HomePageLoaded.fromMap(json.decode(source) as Map<String, dynamic>);
}
