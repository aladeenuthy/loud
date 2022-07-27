import 'package:get/get.dart';
import 'package:loud/controllers/songs_controller.dart';

class FavoritesController extends GetxController {
  var numb = 0;
  final songsController = SongsController.to;
  final favoriteSongs = SongsController.to.songs
      .where((element) => element.isFavorite.value)
      .toList()
      .obs;
  final favoriteAlbums = SongsController.to.albums
      .where((element) => element.isFavorite.value)
      .toList()
      .obs;

  static FavoritesController get to => Get.find();
  // to set favorited songs as the  new queue
  void play(int index) {
    songsController.songQueue = favoriteSongs;
    songsController.numb = index + 1;
    songsController.play(favoriteSongs[index], true);
  }
}
