import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/constants.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:loud/controllers/songs_controller.dart';
import 'package:loud/views/dashboard/components/current_song.dart';
import 'package:loud/views/dashboard/favorites/favorites..dart';
import 'package:loud/views/dashboard/playlists/playlists.dart';
import 'package:loud/views/dashboard/search/search.dart';

import '../../models/song.dart';
import 'home/home.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15),
          child: LazyLoadIndexedStack(index: index, children: const [
            Home(),
            Favorites(),
            Search(),
            Playlists(),
          ])),
      floatingActionButtonLocation: const CustomFloatingActionButtonLocation(),
      floatingActionButton: Obx(() {
        var songsController = SongsController.to;
        return songsController.currentSong.value == null
            ? Container()
            : GestureDetector(
              onTap: (){
                songsController.play(songsController.currentSong.value as Song);
              },
              child: CurrentSong(
                  currentSong: SongsController.to.currentSong.value as Song),
            );
      }),
      bottomNavigationBar: ClipRRect(
        child: BottomNavigationBar(
            showUnselectedLabels: false,
            showSelectedLabels: false,
            onTap: (value) => setState(() {
                  index = value;
                }),
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.music_note),
                  label: "",
                  backgroundColor: primarycolor),
              BottomNavigationBarItem(
                icon: Icon(index == 1 ? Icons.favorite : Icons.favorite_border),
                label: "",
              ),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: ""),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_play), label: "")
            ]),
      ),
    );
  }
}
/*
 FloatingActionButton(
            onPressed: () {
              themeController.switchTheme();
            },
            backgroundColor:
                themeController.isDark.value ? darkcolorLight : primarycolor,
            child: Icon(
              themeController.isDark.value ? Icons.wb_sunny : Icons.brightness_2,
              size: 18,
            ),
          )

*/

class CustomFloatingActionButtonLocation
    implements FloatingActionButtonLocation {
  static const double fabIconHeight = 50.0;

  const CustomFloatingActionButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
        0,
        scaffoldGeometry.scaffoldSize.height -
            (140.0 / 2.7) -
            fabIconHeight -
            (fabIconHeight / 2));
  }
}
