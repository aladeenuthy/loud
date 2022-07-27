import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/constants.dart';
import 'package:loud/models/album.dart';
import 'package:loud/views/dashboard/home/components/album_tile.dart';

class ViewAllAbums extends StatelessWidget {
  final List<Album> albums;
  const ViewAllAbums({super.key, required this.albums});

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
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: Get.width / (Get.height / 1.55)),
                itemCount: albums.length,
                itemBuilder: (_, index) {
                  return AlbumTile(album: albums[index]);
                }),
          ],
        ),
      ),
    );
  }
}
