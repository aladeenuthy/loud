import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Song {
  final int id;
  final String title;
  final String artist;
  final String path;
  final int? albumId;
  RxBool isFavorite;
  RxBool isPlaying;
  Song(
      {required this.id,
      required this.title,
      required this.artist,
      required this.path,
      required this.albumId,
      required this.isFavorite,
      required this.isPlaying});

  factory Song.fromSongModel(SongModel songModel, bool isFavorite) {
    return Song(
        id: songModel.id,
        title: songModel.title,
        artist: songModel.artist ?? "unknown",
        path: songModel.data,
        isFavorite: isFavorite.obs,
        albumId: songModel.albumId,
        isPlaying: false.obs);
  }
}
