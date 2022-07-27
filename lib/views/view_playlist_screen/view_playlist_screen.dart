import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/constants.dart';
import 'package:loud/controllers/view_playlist_controller.dart';

import '../../models/playlist.dart';
import 'components/playlist_song_tile.dart';

class ViewPlaylistScreen extends GetView<ViewPlaylistController> {
  final Playlist playlist;
  const ViewPlaylistScreen({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    Get.put(ViewPlaylistController(playlist));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              controller.addSongsToPlaylist();
            },
            icon: const Icon(Icons.add),
            color: primarycolor,
          )
        ],
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            )),
        title: Text(
          playlist.name,
          style:  TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Get.isDarkMode ?  Colors.white: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() => ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.playlistSongs.length,
                        itemBuilder: (_, index) => GestureDetector(
                              onTap: () {
                                controller.playPlaylist(index);
                              },
                              child: PlaylistSongTile(
                                key: ValueKey(
                                    controller.playlistSongs[index].id),
                                playlistsong: controller.playlistSongs[index],
                              ),
                            )))
                  ]))),
    );
  }
}
