import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../models/song.dart';

class AddSongsToPlaylist extends StatefulWidget {
  final List<Song> songs;
  const AddSongsToPlaylist({super.key, required this.songs});

  @override
  State<AddSongsToPlaylist> createState() => _AddSongsToPlaylistState();
}

class _AddSongsToPlaylistState extends State<AddSongsToPlaylist> {
  var chosenSongs = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      decoration: BoxDecoration(
          color: Get.isDarkMode ? darkcolor : Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.19),
                spreadRadius: 5,
                blurRadius: 4,
                offset: const Offset(0, 3))
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back(result: null);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  )),
              IconButton(
                  onPressed: () {
                    Get.back(result: chosenSongs);
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.green,
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                key: const ValueKey('addSongsToPlaylist'),
                padding: EdgeInsets.zero,
                itemCount: widget.songs.length,
                itemBuilder: (_, index) => CheckboxListTile(
                    activeColor: primarycolor,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      widget.songs[index].title.length > 29
                          ? "${widget.songs[index].title.substring(0, 29)}.."
                          : widget.songs[index].title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    value: chosenSongs.contains(widget.songs[index]),
                    onChanged: (value) {
                      if (value!) {
                        chosenSongs.add(widget.songs[index]);
                      } else {
                        chosenSongs.remove(widget.songs[index]);
                      }
                      setState(() {});
                    })),
          )
        ],
      ),
    );
  }
}
