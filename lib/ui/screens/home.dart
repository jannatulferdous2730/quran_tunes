import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quran_tunes/services/auth_service.dart';
import 'package:quran_tunes/controllers/qari_controller.dart';
import 'package:quran_tunes/ui/screens/user_profile.dart';
import '../../controllers/favorite_controller.dart';
import 'player_page.dart';
import 'sign_in_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final QariController qariController = Get.put(QariController());

    Future.microtask(() => authService.loadCurrentUser());

    var size = Get.size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/vectors/logo.svg',
          height: size.height * 0.05,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => const UserProfile());
            },
            child: Obx(() => Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: authService.photoUrl.isNotEmpty
                      ? CircleAvatar(
                          radius: 18,
                          backgroundImage:
                              NetworkImage(authService.photoUrl.value),
                        )
                      : const Icon(
                          CupertinoIcons.person_alt_circle,
                          color: Colors.white,
                          size: 30,
                        ),
                )),
          ),
        ],
      ),
      body: Obx(() {
        if (qariController.qariData.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return DefaultTabController(
          length: qariController.qariData.length,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                items: [
                  Stack(
                      children: [
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: SvgPicture.asset('assets/vectors/Carousel_m.svg')),
                        Positioned(
                            left: size.width * .63,
                            child: Image.asset("assets/images/lamp_m.png"))
                      ],
                  ),
                  Stack(
                    children: [
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: SvgPicture.asset('assets/vectors/Carousel_s.svg')),
                      Positioned(
                          left: size.width * .49,
                          bottom: 4,
                          child: Image.asset("assets/images/tosbi_s.png"))
                    ],
                  ),Stack(
                    children: [
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: SvgPicture.asset('assets/vectors/Carousel_b.svg')),
                      Positioned(
                          left: size.width * .55,
                          bottom: 3,
                          child: Image.asset("assets/images/quran_b.png"))
                    ],
                  ),
                ],
                options: CarouselOptions(
                  height: size.height * 0.255,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(seconds: 2),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  viewportFraction: 1,
                ),
              ),
              SizedBox(height: size.height * 0.015,),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "Reciters",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w600),
                ),
              ),
              TabBar(
                padding: const EdgeInsets.only(left: 10),
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerHeight: 0,
                indicatorColor: CupertinoColors.activeGreen,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                tabs: qariController.qariData.map((qari) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(qari['imagePath']),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: size.height * 0.015),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text("Surahs:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.w600)),
              ),
              Expanded(
                child: TabBarView(
                  children: qariController.qariData.map((qari) {
                    final surahs = qari['surahs'];
                    return ListView.builder(
                      itemCount: surahs.length,
                      itemBuilder: (context, index) {
                        final surah = surahs[index];
                        return GestureDetector(
                          onTap: () => Get.to(() => PlayerPage(
                            surahName: surah['name'],
                            qariName: qari['qariName'],
                            audioPath: surah['audioPath'],
                            duration: surah['duration'],
                            qariImagePath: qari['imagePath'],
                          )),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(CupertinoIcons.play_arrow_solid),
                            ),
                            title: Text(
                              surah['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "Duration: ${surah['duration']}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: Obx(() {
                              final isFavorite = Get.find<FavoriteController>()
                                  .favorites
                                  .any((fav) => fav['surahName'] == surah['name']);
                              final favoriteId = isFavorite
                                  ? Get.find<FavoriteController>()
                                  .favorites
                                  .firstWhere((fav) => fav['surahName'] == surah['name'])['id']
                                  : null;

                              return IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: CupertinoColors.inactiveGray
                                ),
                                onPressed: () {
                                  Get.find<FavoriteController>().toggleFavorite(
                                    surah['name'],
                                    qari['qariName'],
                                    surah['audioPath'],
                                    isFavorite,
                                    favoriteId,
                                  );
                                },
                              );
                            }),
                          ),
                        );

                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
