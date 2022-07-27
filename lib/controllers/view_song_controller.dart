import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:loud/controllers/songs_controller.dart';

import '../models/song.dart';

class ViewSongController extends GetxController {
  late Rx<Song> song;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;
  final songController = SongsController.to;
  ViewSongController(this.song);
  static ViewSongController get to => Get.find();


  @override
  void onInit() {
    super.onInit();
    fetchInitialDurationAndPosition();
    songController.audioPlayer.onPlayerStateChanged.listen((event) {
      songController.pausedOrPlayed.value = event == PlayerState.playing;
    });
    songController.audioPlayer.onDurationChanged.listen((newDuration) {
      duration.value = newDuration;
    });
    songController.audioPlayer.onPositionChanged.listen((newPosition) {
      position.value = newPosition;
    });
  }

  void fetchInitialDurationAndPosition() async {
    duration.value =
        await songController.audioPlayer.getDuration() ?? Duration.zero;
    position.value =
        await songController.audioPlayer.getCurrentPosition() ?? Duration.zero;
  }

  void seek(int value) async {
    final positionSeek = Duration(seconds: value);
    await songController.audioPlayer.seek(positionSeek);
    position.value =
        await songController.audioPlayer.getCurrentPosition() ?? Duration.zero;
  }

  void next() {
    var res = songController.next();
    if (res != null) {
      song.value = res;
    }
  }

  void previous() {
    var res = songController.previous();
    if (res != null) {
      song.value = res;
    }
  }
}
