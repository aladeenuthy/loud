import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../../../constants.dart';
import '../../../controllers/songs_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../models/song.dart';

class CurrentSong extends StatelessWidget {
  final Song currentSong;
  const CurrentSong({super.key, required this.currentSong});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: ThemeController.to.isDark.value
                  ? darkcolorLight
                  : primarycolorLight
              ,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 7,),
          leading: Hero(
            tag:currentSong.id,
            child: QueryArtworkWidget(
                    artworkBorder: BorderRadius.circular(10),
                    id: currentSong.id,
                    type: ArtworkType.AUDIO,
                    artworkHeight: 50,
                  ),
          ),
          title: Text(
            currentSong.title.length > 25
                ? "${currentSong.title.substring(0, 22)}.."
                : currentSong.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            currentSong.artist.length > 25
                ? "${currentSong.artist.substring(0, 22)}.."
                : currentSong.artist,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          trailing: 
            Obx(() {
                  return IconButton(
                    onPressed: () {
                      SongsController.to.pausePlay();
                    },
                    icon: Icon(SongsController.to.pausedOrPlayed.value
                        ? Icons.pause
                        : Icons.play_arrow),
                    color: primarycolor,
                  );
                })
              ,
        ),
      );
    });
    
  }
}
/* 
const SizedBox(

            height: 20,
            width: 50,
            child: MusicVisualizer(
            
              barCount: 4,
              colors: [darkcolor,
                primarycolor,
                darkcolor,
                darkcolor,
              ],
              duration: [900, 600, 900, 600],
            ),
          )
*/