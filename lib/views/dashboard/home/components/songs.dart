import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/controllers/songs_controller.dart';
import 'package:loud/views/dashboard/components/song_tile.dart';

import '../../../../models/song.dart';

class Songs extends StatelessWidget {
  final List<Song> songs;
  const Songs({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: const ValueKey("home"),
        controller: ScrollController(),
        padding: EdgeInsets.only(bottom: Get.bottomBarHeight),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: songs.length,
        itemBuilder: (_, index) => GestureDetector(
            key: ValueKey(songs[index].id),
            onTap: () {
              SongsController.to.play(songs[index], false, index);
            },
            child: SongTile(song: songs[index])));
  }
}
