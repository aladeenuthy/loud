import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loud/controllers/favorites_controller.dart';
import 'package:loud/controllers/view_song_controller.dart';
import 'package:loud/models/album.dart';
import 'package:loud/models/song.dart';
import 'package:loud/views/dashboard/home/components/view_all_album.dart';
import 'package:loud/views/view_song/view_song.dart';
import 'package:on_audio_query/on_audio_query.dart';

///refactor and check well for repeated stuff

enum RepeatMode {
  noRepeat,
  repeatList,
  onlyRepeatCurrentSong,
}

RepeatMode stringToEnum(String enumString) {
  RepeatMode enumConvert =
      RepeatMode.values.firstWhere((e) => e.toString() == enumString);

  return enumConvert;
}

class SongsController extends GetxController {
  final OnAudioQuery audioQuery;
  final box = GetStorage();
  SongsController(this.audioQuery);
  final _audioPlayer = AudioPlayer();
  List<Song> _songs = [];
  List<Album> _albums = [];
  var currentSong = Rxn<Song>();
  var songsRepeatMode = RepeatMode.noRepeat.obs;
  var isLoading = false;
  var pausedOrPlayed = false.obs;
  var numb = 0;
  StreamSubscription<void>? streamSubscription;
  List<Song> songQueue = [];
  static SongsController get to => Get.find();
  List<Song> get songs {
    return _songs;
  }

  AudioPlayer get audioPlayer {
    return _audioPlayer;
  }

  List<Album> get albums {
    return _albums;
  }

  @override
  void onInit() {
    super.onInit();
    if (box.read("repeatMode") == null) {
      songsRepeatMode.value = RepeatMode.noRepeat;
    } else {
      songsRepeatMode.value = stringToEnum(box.read("repeatMode"));
    }

    // stream subscription for handling song queues
    streamSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      if (numb >= songQueue.length &&
          songsRepeatMode.value == RepeatMode.repeatList) {
        numb = 0;
      } else if (numb >= songQueue.length &&
          songsRepeatMode.value != RepeatMode.repeatList) {
        return;
      }
      _playLogic(songQueue[numb]);
      final isRegistered = Get.isRegistered<ViewSongController>();
      if (isRegistered) {
        // if in view song screen switch song to new song so as to get new song info
        ViewSongController.to.song.value = songQueue[numb];
      }
      numb += 1;
    });
  }

  @override
  void onClose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    streamSubscription?.cancel();
    super.onClose();
  }

  List<Song> convertFromSongModelToSong(List<SongModel> queriedSongs) {
    var prefsSongFav = box.read<List>("songFavorites") ?? [];
    final convertSongs = queriedSongs.map((songModel) {
      var song = Song.fromSongModel(
          songModel, prefsSongFav.contains(songModel.id.toString()));
      return song;
    }).toList();
    return convertSongs;
  }

  void fetchSongs() async {
    _updateIsLoding(true);
    var prefsAlbumFav = box.read<List>("albumFavorites") ?? [];
    final queriedSongs = await audioQuery.querySongs();
    final queriedAlbums = await audioQuery.queryAlbums();
    final convertSongs = convertFromSongModelToSong(queriedSongs);
    List<Album> convertAlbum = [];
    for (var albumModel in queriedAlbums) {
      var artist = albumModel.artist ?? "<unknown>";
      if (artist != "<unknown>") {
        var album = Album.fromAlbumModel(
            albumModel, prefsAlbumFav.contains(albumModel.id.toString()));
        convertAlbum.add(album);
      }
    }
    _songs = convertSongs;
    _albums = convertAlbum;
    songQueue = _songs;
    _updateIsLoding(false);
  }

  void _updateIsLoding(bool currentStatus) {
    isLoading = currentStatus;
    update();
  }



  // toggling songs and album favorites
  void toggleSongFavorites(Song song) {
    var prefsSongFav = box.read<List>("songFavorites") ?? [];
    final isRegistered = Get.isRegistered<FavoritesController>();
    if (!isRegistered) {
      Get.lazyPut(() => FavoritesController());
    }
    if (song.isFavorite.value) {
      prefsSongFav.remove(song.id.toString());
      FavoritesController.to.favoriteSongs.remove(song);
    } else {
      prefsSongFav.add(song.id.toString());
      FavoritesController.to.favoriteSongs.add(song);
    }
    box.write("songFavorites", prefsSongFav);
    song.isFavorite.toggle();
  }

  void toggleAlbumFavorites(Album album) {
    var prefsAlbumFav = box.read<List>("albumFavorites") ?? [];
    final isRegistered = Get.isRegistered<FavoritesController>();
    if (!isRegistered) {
      Get.lazyPut(() => FavoritesController());
    }
    if (album.isFavorite.value) {
      prefsAlbumFav.remove(album.id.toString());
      FavoritesController.to.favoriteAlbums.remove(album);
    } else {
      prefsAlbumFav.add(album.id.toString());
      FavoritesController.to.favoriteAlbums.add(album);
    }
    box.write("albumFavorites", prefsAlbumFav);
    album.isFavorite.toggle();
  }

  void _playLogic(Song song) async {
    currentSong.value?.isPlaying.value =
        false; // for adding/ removing visualiser to a song tile
    await _audioPlayer.play(DeviceFileSource(song.path));
    currentSong.value = song;
    song.isPlaying.value = true;
    pausedOrPlayed.value = _audioPlayer.state == PlayerState.playing;
  }

  void play(Song song, [bool fromAlbum = false, int? index]) {
    if (currentSong.value?.id == song.id) {
      Get.to(
        () => ViewSongScreen(song: song),
      );
      return;
    }
    if (!fromAlbum) {
      songQueue = _songs;
      _playLogic(song);
      numb = index ?? 0;
      numb += 1;
      return;
    }
    _playLogic(song);
  }

  void pausePlay() async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    pausedOrPlayed.value = _audioPlayer.state == PlayerState.playing;
  }



  void setRepeatMode() async {
    if (songsRepeatMode.value == RepeatMode.noRepeat) {
      songsRepeatMode.value = RepeatMode.repeatList;
    } else if (songsRepeatMode.value == RepeatMode.repeatList) {
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      songsRepeatMode.value = RepeatMode.onlyRepeatCurrentSong;
    } else {
      await audioPlayer.setReleaseMode(ReleaseMode.release);
      songsRepeatMode.value = RepeatMode.noRepeat;
    }
    await box.write('repeatMode', songsRepeatMode.value.toString());
  }



  // to next and previous songs 
  Song? next() {
    if (numb >= songQueue.length) {
      numb = songQueue.length;
      return null;
    }
    var song = songQueue[numb];
    _playLogic(song);
    numb += 1;
    return song;
  }

  Song? previous() {
    numb -= 2;
    if (numb < 0) {
      numb = 1;
      return null;
    }
    var song = songQueue[numb];
    _playLogic(songQueue[numb]);
    numb += 1;
    return song;
  }



  void showAllAlbums() {
    Get.bottomSheet(
      ViewAllAbums(albums: albums),
      isScrollControlled: true,
    );
  }
}
