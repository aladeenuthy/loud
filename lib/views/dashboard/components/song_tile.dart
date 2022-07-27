import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/constants.dart';
import 'package:loud/controllers/playlist_controller.dart';
import 'package:loud/controllers/songs_controller.dart';
import 'package:loud/controllers/theme_controller.dart';
import 'package:loud/views/dashboard/components/visualizer.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../models/song.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final int? index;
  final bool? inAlbum;
  const SongTile({Key? key, required this.song, this.inAlbum, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 7),
        leading: inAlbum != null
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    color: primarycolorLight,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  index.toString(),
                  style: const TextStyle(color: primarycolor),
                ),
              )
            : QueryArtworkWidget(
                artworkBorder: BorderRadius.circular(10),
                id: song.id,
                type: ArtworkType.AUDIO,
                artworkHeight: 50,
              ),
        title: Text(
          song.title.length > 20
              ? "${song.title.substring(0, 20)}.."
              : song.title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          song.artist.length > 25
              ? "${song.artist.substring(0, 22)}.."
              : song.artist,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        trailing: Obx(() => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (song.isPlaying.value)
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 20,
                    width: 20,
                    child: Obx(() {
                      final themeController = ThemeController.to;
                      final songsController = SongsController.to;
                      return songsController.pausedOrPlayed.value ? MusicVisualizer(
                        barCount: 4,
                        colors: themeController.isDark.value
                            ? darkModeColorList
                            : lightModeColorList,
                        duration: const [900, 600, 900, 600],
                      ): Visualizer(visualizerColor: themeController.isDark.value
                                  ? darkModeColorList
                                  : lightModeColorList);
                    }),
                  ),
                PopupMenuButton<int>(
                  onSelected: (value) {
                    if (value == 0) {
                      SongsController.to.toggleSongFavorites(song);
                    } else {
                      final isRegistered =
                          Get.isRegistered<PlayListController>();
                      if (!isRegistered) {
                        Get.lazyPut(() => PlayListController());
                      }
                      PlayListController.to.addSongToPlaylist(song);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(
                              song.isFavorite.value
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: primarycolor,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(song.isFavorite.value ? 'unlove' : 'love'),
                          ],
                        )),
                    PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: const [
                            Icon(Icons.playlist_add),
                            SizedBox(
                              width: 7,
                            ),
                            Text("playlist add"),
                          ],
                        ))
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
