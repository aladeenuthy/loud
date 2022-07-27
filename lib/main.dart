import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/controllers/songs_controller.dart';
import 'package:loud/controllers/theme_controller.dart';
import 'package:loud/theme.dart';
import 'package:loud/views/dashboard/dashboard.dart';
import "package:get_storage/get_storage.dart";
import 'package:on_audio_query/on_audio_query.dart';

requestPermission() async {
  final audio = OnAudioQuery();
  bool permissionStatus = await audio.permissionsStatus();
  if (permissionStatus) {
    return;
  }
  await audio.permissionsRequest();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermission();
  await GetStorage.init();
  Get.put(ThemeController());
  Get.put(SongsController(OnAudioQuery()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.leftToRightWithFade,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      darkTheme: darkTheme(),
      theme: lightTheme(),
      home: const DashBoard(),
    );
  }
}
