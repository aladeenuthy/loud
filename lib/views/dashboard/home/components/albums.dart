import 'package:flutter/material.dart';
import 'package:loud/views/dashboard/home/components/album_tile.dart';
import '../../../../models/album.dart';

class Albums extends StatelessWidget {
  final List<Album> albums;
  const Albums({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        itemBuilder: (_, index) => AlbumTile(
          album: albums[index],
        ),
      ),
    );
  }
}
