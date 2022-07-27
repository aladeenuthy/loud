import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/constants.dart';
import 'package:loud/controllers/playlist_controller.dart';
import 'package:loud/models/playlist.dart';

import '../../playlists/components/create_grid.dart';
import '../../playlists/components/playlist_grid.dart';

class AddSongToPlaylist extends StatelessWidget {
  final List<Playlist> playlists;
  const AddSongToPlaylist({super.key, required this.playlists});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
      decoration: BoxDecoration(
          color: Get.isDarkMode ? darkcolor : Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50))),
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            const Center(
              child: SizedBox(
                  width: 70,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 3,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: Get.width / (Get.height / 1.78)),
                  itemCount: playlists.length + 1,
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return GestureDetector(
                          onTap: () {
                            PlayListController.to.addPlaylist();
                          },
                          child: const CreateGrid());
                    }
                    return GestureDetector(
                        onTap: () {
                          Get.back(result: playlists[index - 1]);
                        },
                        child: PlaylistGrid(
                          playlist: playlists[index - 1],
                          index: index - 1,
                        ));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
