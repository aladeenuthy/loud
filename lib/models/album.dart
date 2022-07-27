import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Album {
  final int id;
  final String title;
  final String artist;
  RxBool isFavorite;
  Album(
      {required this.id,
      required this.title,
      required this.artist,
      required this.isFavorite});

  factory Album.fromAlbumModel(AlbumModel albumModel, bool isFavorite) {
    return Album(
        id: albumModel.id,
        title: albumModel.album,
        artist: albumModel.artist ?? "unknown",
        isFavorite: isFavorite.obs);
  }
}
