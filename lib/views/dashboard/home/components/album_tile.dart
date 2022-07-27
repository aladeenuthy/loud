import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../../models/album.dart';
import '../../../view_album/view_album_screen.dart';

class AlbumTile extends StatelessWidget {
  final Album album;
  const AlbumTile({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
              Get.to(()=>ViewAlbumScreen(album: album));
            },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          QueryArtworkWidget(
            artworkBorder: BorderRadius.circular(8),
            id: album.id,
            type: ArtworkType.ALBUM,
            artworkWidth: 200,
            artworkHeight: 100,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            album.title.length > 7? "${album.title.substring(0, 7)}.."
                : album.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            album.artist.length > 9 ? "${album.artist.substring(0, 9)}.." : album.artist,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    );
  }
}
