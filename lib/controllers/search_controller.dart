import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/controllers/songs_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../models/song.dart';

class SearchController extends GetxController {
  var isLoading = false.obs;
  List<Song> searchResult = [];
  var searchParam = "".obs;
  var searchParamController = TextEditingController();
  var songsController = SongsController.to;

  void search() async {
    isLoading.value = true;
    final result = await songsController.audioQuery
        .queryWithFilters(searchParam.value, WithFiltersType.AUDIOS);
    List<Song> convertResult = [];
    var songs = songsController.songs;
    for (var song in result) {
      try {
        var s = songs.firstWhere((element) => element.id == song['_id']);
        convertResult.add(s);
      } catch (_) {}
    }
    searchResult = convertResult;
    isLoading.value = false;
  }

  void clear() {
    if (searchParamController.text.isEmpty) {
      return;
    }
    isLoading.value = true; // to refresh
    Get.focusScope?.unfocus();
    searchParamController.clear();
    searchResult = [];
    songsController.songQueue = searchResult;
    isLoading.value = false;
  }

  //to set searched songs to queue
  void play(int index) {
    songsController.songQueue = searchResult;
    songsController.numb = index + 1;
    songsController.play(searchResult[index], true);
  }
}
