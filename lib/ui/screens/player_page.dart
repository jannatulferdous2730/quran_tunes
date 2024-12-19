import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/player_controller.dart';

class PlayerPage extends StatelessWidget {
  final String surahName;
  final String qariName;
  final String audioPath;
  final String duration;
  final String qariImagePath;

  PlayerPage({
    super.key,
    required this.surahName,
    required this.qariName,
    required this.audioPath,
    required this.duration,
    required this.qariImagePath,
  });

  final PlayerController playerController = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    var size = Get.size;

    // Initialize the audio when the page is built
    playerController.initAudio(audioPath);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Now playing",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_outlined, color: Colors.white),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        child: Column(
          children: [
            Container(
              height: size.height * .5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(qariImagePath),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surahName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      qariName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey),
                    )
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    size: 25,
                    color: CupertinoColors.darkBackgroundGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Obx(() {
                  double sliderValue = (playerController.totalDuration.value?.inMilliseconds ?? 0) > 0
                      ? playerController.currentPosition.value.inMilliseconds /
                          playerController.totalDuration.value!.inMilliseconds
                      : 0.0;

                  return Slider(
                    value: sliderValue.clamp(0.0, 1.0),
                    onChanged: (value) {
                      final newPosition =
                          Duration(milliseconds: (value * playerController.totalDuration.value!.inMilliseconds).toInt());
                      playerController.seekAudio(newPosition);
                    },
                  );
                }),
                const SizedBox(height: 20),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(playerController.currentPosition.value),
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        _formatDuration(playerController.totalDuration.value ?? Duration.zero),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => GestureDetector(
                    onTap: () => playerController.playPauseAudio(),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff42C83C),
                      ),
                      child: Icon(
                        playerController.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}
