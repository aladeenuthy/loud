import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/controllers/view_album_controller.dart';
import 'package:loud/models/album.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../constants.dart';
import '../../controllers/songs_controller.dart';
import '../dashboard/components/song_tile.dart';

class ViewAlbumScreen extends GetView<ViewAlbumController> {
  final Album album;
  const ViewAlbumScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    Get.put(ViewAlbumController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            )),
      ),
      body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GetBuilder<ViewAlbumController>(initState: (_) {
              controller.fetchAlbumSongs(album.id);
            }, builder: (_) {
              return Column(children: [
                QueryArtworkWidget(
                  artworkBorder: BorderRadius.circular(8),
                  id: album.id,
                  type: ArtworkType.ALBUM,
                  artworkWidth: 150,
                  artworkHeight: 150,
                ),
                const SizedBox(height: 10),
                Text(
                  album.title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 7,),
                Text(
                  album.artist,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: primarycolor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20)),
                        onPressed: () {
                          controller.playAlbum();
                        },
                        child: Row(children: const [
                          Icon(Icons.play_arrow, color: primarycolor),
                          SizedBox(width: 3),
                          Text(
                            "Play",
                            style: TextStyle(fontSize: 16, color: primarycolor),
                          )
                        ])),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: primarycolor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10)),
                        onPressed: () {},
                        child: Obx(() {
                          return IconButton(
                              onPressed: () {
                                SongsController.to.toggleAlbumFavorites(album);
                              },
                              icon: Icon(
                                album.isFavorite.value
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: primarycolor,
                              ));
                        }))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.albumSongs.length,
                    itemBuilder: (_, index) => GestureDetector(
                          onTap: () {
                            controller.playAlbum(index);
                          },
                          child: SongTile(
                            key: ValueKey(controller.albumSongs[index].id),
                            song: controller.albumSongs[index],
                            index: index + 1,
                            inAlbum: true,
                          ),
                        ))
              ]);
            }),
          )),
    );
  }
}
