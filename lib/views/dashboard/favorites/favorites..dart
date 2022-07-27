
import 'package:loud/controllers/favorites_controller.dart';
import 'package:get/get.dart';
import 'package:loud/views/dashboard/components/song_tile.dart';
import 'package:loud/views/dashboard/home/components/albums.dart';
import 'package:flutter/material.dart';

class Favorites extends GetView<FavoritesController> {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FavoritesController>()) {
      Get.put(FavoritesController());
    }
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Favorites",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              return controller.favoriteAlbums.isEmpty
                  ? const Text("")
                  : Albums(albums: controller.favoriteAlbums);
            }),
            Obx(() {
              return ListView.builder(
                  key: const ValueKey('favorites'),
                  padding: EdgeInsets.only(right: 15, bottom: Get.bottomBarHeight),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.favoriteSongs.length,
                  itemBuilder: (_, index) => GestureDetector(
                        key: ValueKey(controller.favoriteSongs[index].id),
                        onTap: () {
                          controller.play(index);
                        },
                        child: SongTile(song: controller.favoriteSongs[index]),
                      ));
            })
          ],
        ),
      ),
    );
  }
}

