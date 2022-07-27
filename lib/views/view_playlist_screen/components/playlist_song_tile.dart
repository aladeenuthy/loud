import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/controllers/view_playlist_controller.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../constants.dart';
import '../../../controllers/songs_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../models/song.dart';
import '../../dashboard/components/visualizer.dart';

class PlaylistSongTile extends StatelessWidget {
  final Song playlistsong;
  const PlaylistSongTile({super.key, required this.playlistsong});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(playlistsong.id),
      onDismissed: (_) {
        ViewPlaylistController.to.removeFromPlaylist(playlistsong.id);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.red,
        ),
        child: const Icon(Icons.remove),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 7),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 7),
          leading: QueryArtworkWidget(
            artworkBorder: BorderRadius.circular(10),
            id: playlistsong.id,
            type: ArtworkType.AUDIO,
            artworkHeight: 50,
          ),
          title: Text(
            playlistsong.title.length > 25
                ? "${playlistsong.title.substring(0, 22)}.."
                : playlistsong.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            playlistsong.artist.length > 25
                ? "${playlistsong.artist.substring(0, 22)}.."
                : playlistsong.artist,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          trailing: Obx(() {
            return playlistsong.isPlaying.value
                ? Container(
                    alignment: Alignment.bottomCenter,
                    height: 20,
                    width: 20,
                    child: Obx(() {
                      final themeController = ThemeController.to;
                      final songsController = SongsController.to;
                      return songsController.pausedOrPlayed.value
                          ? MusicVisualizer(
                              barCount: 4,
                              colors: themeController.isDark.value
                                  ? darkModeColorList
                                  : lightModeColorList,
                              duration: const [900, 600, 900, 600],
                            )
                          : Visualizer(
                              visualizerColor: themeController.isDark.value
                                  ? darkModeColorList
                                  : lightModeColorList);
                    }),
                  )
                : const Text("");
          }),
        ),
      ),
    );
  }
}
