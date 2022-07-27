import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/constants.dart';
import 'package:loud/controllers/songs_controller.dart';
import 'package:loud/views/dashboard/home/components/albums.dart';
import 'package:loud/views/dashboard/home/components/songs.dart';

import '../../../controllers/theme_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: SafeArea(
        child: GetBuilder<SongsController>(
            initState: (_) => SongsController.to.fetchSongs(),
            builder: (controller) {
              return controller.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primarycolor),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          const Text(
          "Loud",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold),
        ),
                        
                          Obx(() {
                                final themeController = ThemeController.to;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        themeController.isDark.value
                                            ? darkcolorLight
                                            : primarycolor,
                                    child: IconButton(
                                      onPressed: () {
                                        themeController.switchTheme();
                                      },
                                      color: themeController.isDark.value
                                          ? primarycolor
                                          : darkcolorLight,
                                      icon: Icon(
                                        themeController.isDark.value
                                            ? Icons.wb_sunny
                                            : Icons.brightness_2,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              })
                        ],),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Albums",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.showAllAlbums();
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Text(
                                  'View All',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Albums(
                          albums: controller.albums,
                        ),
                        const Text(
                          "Songs",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Songs(
                            songs: controller.songs,
                          ),
                        )
                      ],
                    );
            }),
      ),
    );
  }
}
