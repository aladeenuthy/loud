import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/constants.dart';
import 'package:loud/controllers/search_controller.dart';
import 'package:loud/controllers/theme_controller.dart';

import '../components/song_tile.dart';

class Search extends GetView<SearchController> {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchController());
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Obx(()=> TextField(
                  controller: controller.searchParamController,
                  onChanged: (value) {
                    controller.searchParam.value = value;
                    controller.search();
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    fillColor:ThemeController.to.isDark.value ? darkcolorLight: primarycolorLight,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30)),
                    hintText: "search",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: controller.clear,
                    ),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              if (controller.searchParam.isEmpty) {
                return Container();
              }
              return controller.isLoading.value
                  ? const SizedBox(
                      height: 200,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: primarycolor,
                      )),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(right: 15),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.searchResult.length,
                      itemBuilder: (_, index) => GestureDetector(
                            onTap: () {
                              controller.play(index);
                            },
                            child:
                                SongTile(song: controller.searchResult[index]),
                          ));
            })
          ],
        ),
      ),
    );
  }
}
