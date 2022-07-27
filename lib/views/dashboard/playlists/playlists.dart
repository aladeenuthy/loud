import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/constants.dart';
import 'package:loud/controllers/playlist_controller.dart';
import 'package:loud/views/dashboard/playlists/components/create_grid.dart';
import 'package:loud/views/dashboard/playlists/components/playlist_grid.dart';
import 'package:loud/views/view_playlist_screen/view_playlist_screen.dart';

class Playlists extends GetView<PlayListController> {
  const Playlists({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PlayListController());
    return SafeArea(
      child: Obx(() {
        return controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: primarycolor,
                ),
              )
            : GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: Get.width / (Get.height / 1.78)),
                itemCount: controller.playlists.length + 1,
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return GestureDetector(
                        onTap: () {
                          controller.addPlaylist();
                        },
                        child: const CreateGrid());
                  }
                  var playlist = controller.playlists[index - 1];
                  return GestureDetector(
                      onLongPressEnd: (_) async {
                        controller.removePlayist(playlist);
                      },
                      onTap: () {
                        Get.to(()=>ViewPlaylistScreen(playlist: playlist));
                      },
                      child: PlaylistGrid(
                        playlist: playlist,
                        index: index - 1,
                      ));
                });
      }),
    );
  }
}
