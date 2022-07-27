import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/constants.dart';
import 'package:loud/controllers/songs_controller.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import '../views/dashboard/home/components/add_song_to_playlist.dart';

class PlayListController extends GetxController {
  var isLoading = false.obs;
  var playlists = RxList<Playlist>();
  final songsController = SongsController.to;
  static PlayListController get to => Get.find();
  @override
  void onInit() {
    fetchPlaylist();
    super.onInit();
  }

  void fetchPlaylist() {
    isLoading.value = true;
    var playlistBox = songsController.box.read<Map>("playlists") ?? {};
    List<Playlist> convertPlaylist = [];
    playlistBox.forEach((key, value) {
      convertPlaylist.add(Playlist(name: key, numOfSongs: value.length));
    });
    playlists.value = convertPlaylist;
    isLoading.value = false;
  }

  void addPlaylist() async {
    var name = '';
    final result = await Get.defaultDialog(
        backgroundColor: Get.isDarkMode ? darkcolor : Colors.white,
        barrierDismissible: true,
        title: "playlist",
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                onChanged: (val) {
                  name = val;
                },
                decoration: const InputDecoration(hintText: 'name'),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back(result: false);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      )),
                  IconButton(
                      onPressed: () {
                        if (name.isNotEmpty) {
                          Get.back(result: true);
                          return;
                        }
                        Get.snackbar("Loud", "fill the field dumb ass",backgroundColor: Get.isDarkMode ? darkcolorLight : primarycolorLight);
                      },
                      icon: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ))
                ],
              )
            ],
          ),
        ));
    if (result == null || !result) {
      return;
    }

    var playlistsBox = songsController.box.read<Map>('playlists') ?? {};
    if (playlistsBox.containsKey(name)) {
      Get.snackbar("Loud", "playlist $name already exists");
      return;
    }
    playlistsBox[name] = [];
    await songsController.box.write('playlists', playlistsBox);
    playlists.add(Playlist(name: name, numOfSongs: 0));
  }

  void removePlayist(Playlist playlist) async {
    var result = await Get.defaultDialog(
      backgroundColor: Get.isDarkMode ? darkcolor : Colors.white,
      title: "remove ${playlist.name}",
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back(result: false);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  )),
              IconButton(
                  onPressed: () {
                    Get.back(result: true);
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ))
            ],
          )
        ],
      ),
    );
    if (result == null || !result) {
      return;
    }
    var playlistsBox = songsController.box.read<Map>('playlists') ?? {};
    playlistsBox.remove(playlist.name);
    await songsController.box.write('playlists', playlistsBox);
    playlists.remove(playlist);
  }

  void addSongToPlaylist(Song song) async {
    var res = await Get.bottomSheet(
        isScrollControlled: true,
        AddSongToPlaylist(playlists: playlists,)
        );
    if (res == null) {
      return;
    }
    var playlistsBox = songsController.box.read<Map>('playlists') ?? {};
    var inPlaylist = playlistsBox[res.name].contains(song.id);
    if (!inPlaylist) {
      playlistsBox[res.name].add(song.id);
      await songsController.box.write('playlists', playlistsBox);
      Get.snackbar("Loud", "added to ${res.name}", backgroundColor: Get.isDarkMode ? darkcolorLight : primarycolorLight);
      fetchPlaylist();
      return;
    }
    Get.snackbar("Loud", "already in playlist",backgroundColor: Get.isDarkMode ? darkcolorLight : primarycolorLight);
  }
}
