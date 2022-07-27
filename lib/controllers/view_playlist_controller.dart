import 'package:get/get.dart';
import 'package:loud/controllers/playlist_controller.dart';
import 'package:loud/controllers/songs_controller.dart';
import 'package:loud/models/song.dart';
import '../constants.dart';
import '../models/playlist.dart';
import '../views/view_playlist_screen/components/add_songs_to_playlist.dart';

class ViewPlaylistController extends GetxController {
  var isLoading = false.obs;
  var playlistSongs = RxList<Song>();
  final songsController = SongsController.to;
  var hasSubscribed = false;
  var numb = 0;
  final Playlist playlist;
  static ViewPlaylistController get to => Get.find();
  ViewPlaylistController(this.playlist);
  @override
  void onInit() {
    fetchPlaylistSongs();
    super.onInit();
  }

  void fetchPlaylistSongs() async {
    isLoading.value = true;
    var playlistsBox = songsController.box.read<Map>('playlists') ?? {};
    var playlistSongsBox = playlistsBox[playlist.name];
    var songs = songsController.songs;
    List<Song> getSongs = [];
    for (var id in playlistSongsBox) {
      try {
        var s = songs.firstWhere((element) => element.id == id);
        getSongs.add(s);
      } catch (_) {}
    }
    playlistSongs.value = getSongs;
    isLoading.value = false;
  }

  void removeFromPlaylist(int songId) async {
    var playlistsBox = songsController.box.read<Map>('playlists') ?? {};
    playlistsBox[playlist.name].remove(songId);
    await songsController.box.write('playlists', playlistsBox);
    Get.snackbar("Loud", "removed from ${playlist.name}",
        backgroundColor: Get.isDarkMode ? darkcolorLight : primarycolorLight);
    PlayListController.to.fetchPlaylist();
    return;
  }

  void playPlaylist([int index = 0]) async {
    if (!hasSubscribed) {
      hasSubscribed = true;
      songsController.songQueue = playlistSongs;
    }
    songsController.numb =  index + 1;
    songsController.play(playlistSongs[index], true);    
  }

  void addSongsToPlaylist() async {
    var result = await Get.bottomSheet(
        AddSongsToPlaylist(
          songs: songsController.songs,
        ),
        isScrollControlled: true);

    if (result != null) {
      var playlistsBox = songsController.box.read<Map>('playlists') ?? {};
      for (var song in result) {
        if (!playlistsBox[playlist.name].contains(song.id)) {
          playlistsBox[playlist.name].add(song.id);
          playlistSongs.add(song);
        }
      }
      await songsController.box.write('playlists', playlistsBox);
      PlayListController.to.fetchPlaylist();
    }
  }
}
