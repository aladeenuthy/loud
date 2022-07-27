import 'package:get/get.dart';
import 'package:loud/controllers/songs_controller.dart';

import '../models/song.dart';

class ViewAlbumController extends GetxController {
  List<Song> albumSongs = [];
  var numb = 0;
  var hasSubscribed = false;
  SongsController songsController = SongsController.to;

  void fetchAlbumSongs(int albumId) async {
    albumSongs =
        songsController.songs.where((song) => song.albumId == albumId).toList();
  }

  void playAlbum([int index = 0]) async {
    if (!hasSubscribed) {
      hasSubscribed = true;
      songsController.songQueue = albumSongs;
    }
    songsController.numb = index + 1;
    songsController.play(albumSongs[index], true);
  }
}
