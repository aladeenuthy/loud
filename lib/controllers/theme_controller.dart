import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  var isDark = false.obs;
  final box = GetStorage();
  static ThemeController get to => Get.find();

  @override
  void onInit() {
    isDark.value = box.read("darkMode") ?? false;
    if(isDark.value){
      Get.changeThemeMode(ThemeMode.dark);
    }
    super.onInit();
  }

  void switchTheme() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    isDark.value = !Get.isDarkMode;
    box.write('darkMode', !Get.isDarkMode);
  }
}
