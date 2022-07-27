import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';
import '../../../../controllers/theme_controller.dart';
import '../../../../models/playlist.dart';

class PlaylistGrid extends StatelessWidget {
  final Playlist playlist;
  final int index;
  const PlaylistGrid({super.key, required this.playlist, required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
              color: ThemeController.to.isDark.value ? darkcolor : Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(
                      ThemeController.to.isDark.value
                          ? 0.05
                          : 0.19,
                    ),
                    spreadRadius: 5,
                    blurRadius: 4,
                    offset: const Offset(0, 3))
              ],
              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.circle_outlined,
                    size: 35,
                    color: Colors.primaries[2],
                  )
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name.length > 9
                        ? '${playlist.name.substring(0, 7)}...'
                        : playlist.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    "${playlist.numOfSongs} songs",
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                ],
              )
            ],
          ),
        ));
  }
}
