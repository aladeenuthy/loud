
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/constants.dart';
import 'package:loud/controllers/songs_controller.dart';
import 'package:loud/controllers/view_song_controller.dart';
import 'package:loud/utils.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../models/song.dart';

class ViewSongScreen extends StatelessWidget {
  final Song song;
  const ViewSongScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewSongController(song.obs));
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
        body: Obx(() {
          return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: Column(
                children: [
                  Hero(
                    tag: controller.song.value.id,
                    child: Obx(() => controller.songController.pausedOrPlayed.value
                        ? Image.asset(
                            'assets/images/dancing-man.gif',
                            height: 150,
                          )
                        : QueryArtworkWidget(
                            artworkBorder: BorderRadius.circular(70),
                            id: controller.song.value.id,
                            type: ArtworkType.AUDIO,
                            artworkWidth: 150,
                            artworkHeight: 150,
                          )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Spacer(
                        flex: 2,
                      ),
                      Obx(() {
                        var icon = Icons.repeat;
                        if (controller.songController.songsRepeatMode.value ==
                            RepeatMode.onlyRepeatCurrentSong) {
                          icon = Icons.repeat_one_rounded;
                        }
                        return IconButton(
                            onPressed: () {
                              controller.songController.setRepeatMode();
                            },
                            icon: Icon(
                              icon,
                              color: controller.songController.songsRepeatMode
                                          .value ==
                                      RepeatMode.noRepeat
                                  ? Colors.grey
                                  : primarycolor,
                            ));
                      }),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            controller.songController
                                .toggleSongFavorites(controller.song.value);
                          },
                          icon: Obx(() => Icon(
                                song.isFavorite.value
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: primarycolor,
                              ))),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    controller.song.value.artist,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    controller.song.value.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  SliderTheme(
                    data: SliderThemeData(
                        overlayShape: SliderComponentShape.noOverlay,
                        trackHeight: 2.5,
                        activeTrackColor: primarycolor,
                        thumbColor: primarycolor,
                        inactiveTrackColor: primarycolorLight),
                    child: Obx(() => Slider(
                          min: 0,
                          max: controller.duration.value.inSeconds.toDouble(),
                          value: controller.position.value.inSeconds.toDouble(),
                          onChanged: (val) {
                            controller.seek(val.toInt());
                          },
                        )),
                  ),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatTime(controller.position.value)),
                          Text(formatTime(controller.duration.value))
                        ],
                      )),
                  Row(
                    children: [
                      const Spacer(flex: 2),
                      IconButton(
                          onPressed: () {
                            controller.previous();
                          },
                          icon: const Icon(
                            Icons.skip_previous,
                            color: Colors.grey,
                          )),
                      const Spacer(),
                      Obx(() => CircleAvatar(
                            radius: 30,
                            backgroundColor: Get.isDarkMode
                                ? darkcolorLight
                                : primarycolorLight,
                            child: IconButton(
                                onPressed: () {
                                  controller.songController.pausePlay();
                                },
                                icon: Icon(
                                  controller.songController.pausedOrPlayed.value
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: primarycolor,
                                )),
                          )),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            controller.next();
                          },
                          icon: const Icon(
                            Icons.skip_next,
                            color: Colors.grey,
                          )),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  )
                ],
              ));
        }));
  }
}
