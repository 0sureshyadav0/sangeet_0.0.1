import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sangeet/consts/consts.dart';
import 'package:sangeet/screens/developer.dart';
import 'package:sangeet/screens/music_player.dart';

import '../providers/music_provider.dart';

class MusicListScreen extends StatefulWidget {
  const MusicListScreen({super.key});

  @override
  State<MusicListScreen> createState() => _MusicListScreenState();
}

class _MusicListScreenState extends State<MusicListScreen> {
  // Sample music list (replace this with your fetched music data)

  List<dynamic> getmusicFiles = [];

  @override
  void initState() {
    super.initState();
    getAudioFiles();
  }

  bool isPermissionGranted = false;
  void getAudioFiles() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        isPermissionGranted = true;
      });

      getmusicFiles =
          await Provider.of<MusicProvider>(context, listen: false).getAudio();
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      Get.snackbar(
        "Storage Permission",
        "Please grant storage permission in order to show music files",
        colorText: Colors.white,
      );
    } else {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        setState(() {
          isPermissionGranted = true;
        });

        getmusicFiles =
            await Provider.of<MusicProvider>(context, listen: false).getAudio();
      } else {
        getAudioFiles();
      }
    }
  }

  bool isAssetPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: appBarColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          centerTitle: true,
          title: const Text(
            "ॐ SANGEET ॐ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const DeveloperContactInfo());
              },
              icon: const CircleAvatar(
                radius: 17.0,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: appBarColor,
                  size: 25.0,
                ),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            // Background image
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  opacity: 0.7,
                  image: AssetImage(
                      "./assets/images/background.jpeg"), // Add your image in assets
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Glassmorphism ListView

            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15.0, right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Sangeet's inbuilt music",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: ListTile(
                              onTap: () async {
                                await _audioPlayer.setSource(AssetSource(
                                    './music/सुरेशको जीवनको कथा.mp3'));

                                if (isAssetPlaying) {
                                  await _audioPlayer.pause();
                                  setState(() {
                                    isAssetPlaying = false;
                                  });
                                } else {
                                  await _audioPlayer.resume();
                                  setState(() {
                                    isAssetPlaying = true;
                                  });
                                }
                              },
                              leading: isAssetPlaying
                                  ? TweenAnimationBuilder(
                                      tween: Tween<double>(
                                          begin: 0,
                                          end: int.parse(240024.toString())
                                                  .toDouble() /
                                              1000),
                                      duration: Duration(
                                          milliseconds:
                                              int.parse(240024.toString())),
                                      builder: (context, double value, child) {
                                        return Transform.rotate(
                                          angle: value,
                                          child: const Icon(
                                            Icons.music_note,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    )
                                  : const Icon(Icons.music_note,
                                      size: 40, color: Colors.white),
                              title: const Text("Suresh's life journey",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ))),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  // SafeArea(child: Text("dhf")),
                  const Text("All Music Files",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                  isPermissionGranted
                      ? Expanded(child: Consumer<MusicProvider>(
                          builder: (context, musicProvider, child) {
                          return ListView.builder(
                            itemCount: getmusicFiles.length,
                            itemBuilder: (context, index) {
                              final music = getmusicFiles[index];
                              return _buildGlassMusicCard(
                                context: context,
                                title: music['title'] ?? "Unknown Title",
                                artist: music['artist'] ?? "Unknown Artist",
                                path: music['path'] ?? "",
                                index: index,
                                duration: music['duration'] ?? "",
                              );
                            },
                          );
                        }))
                      : RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              getAudioFiles();
                            });
                          },
                          child: const Center(
                            child: CircularProgressIndicator(),
                          )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGlassMusicCard({
    required BuildContext context,
    required String title,
    required String artist,
    required String path,
    required int index,
    required String duration,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: ListTile(
              leading:
                  Provider.of<MusicProvider>(context, listen: true).isPlaying &&
                          currentlyPlayingIndex == index
                      ? TweenAnimationBuilder(
                          tween: Tween<double>(
                              begin: 0,
                              end: int.parse(duration).toDouble() / 1000),
                          duration: Duration(milliseconds: int.parse(duration)),
                          builder: (context, double value, child) {
                            return Transform.rotate(
                              angle: value,
                              child: const Icon(
                                Icons.music_note,
                                size: 40,
                                color: Colors.white,
                              ),
                            );
                          },
                        )
                      : const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 40.0,
                        ),
              title: Text(
                title,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                artist,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              trailing: const Icon(Icons.more_vert, color: Colors.white),
              onTap: () {
                setState(() {
                  currentlyPlayingIndex = index;
                });
                Get.to(() => MusicAppHome(
                      title: title,
                      artist: artist,
                      path: path,
                      duration: duration,
                      index: index,
                    ));
              },
            ),
          ),
        ),
      ),
    );
  }

  int currentlyPlayingIndex = 0;
}
