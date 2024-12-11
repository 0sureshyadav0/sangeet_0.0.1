import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MusicProvider extends ChangeNotifier {
  final musicChannel = const MethodChannel("flutter_channel");
  List<dynamic> _getmusicFiles = [];

  List<dynamic> get getmusicFiles => _getmusicFiles;
  int get musicLength => _getmusicFiles.length;
  Future<List<dynamic>> getAudio() async {
    try {
      _getmusicFiles = await musicChannel.invokeMethod("getMusicFiles");
    } on PlatformException {
      Get.snackbar("Error", "Failed to; load music files",
          colorText: Colors.white);
    }
    notifyListeners();
    return _getmusicFiles;
  }

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  void setIsPlaying() {
    if (_isPlaying) {
      _isPlaying = false;
    } else {
      _isPlaying = true;
    }
    notifyListeners();
  }

  Future<void> playMusic(String path, String duration) async {
    try {
      await musicChannel.invokeMethod('playMusic', {'path': path});

      _isPlaying = true;
    } on PlatformException catch (e) {
      Get.snackbar("Error", "${e.message}");
    }
    notifyListeners();
  }

  Future<void> pauseMusic() async {
    try {
      await musicChannel.invokeMethod("pauseMusic");
    } on PlatformException catch (e) {
      Get.snackbar("Error", "${e.message}");
    }

    notifyListeners();
  }

  Future<void> resumeMusic() async {
    try {
      await musicChannel.invokeMethod("resumeMusic");
    } on PlatformException catch (e) {
      Get.snackbar("Error", "${e.message}");
    }

    notifyListeners();
  }

  Future<void> stopMusic() async {
    try {
      await musicChannel.invokeMethod('stopMusic');
      _isPlaying = false;
    } on PlatformException catch (e) {
      Get.snackbar("Error", "${e.message}");
    }
    notifyListeners();
  }

  void seekTo(int duration, int timeDuration) async {
    final position = Duration(milliseconds: duration);
    final newTime = Duration(milliseconds: timeDuration);
    const channel = MethodChannel("flutter_channel");
    try {
      await channel.invokeMethod("seekTo", position.inMilliseconds);

      if (newTime.inSeconds == position.inSeconds) {
        _isPlaying = false;
      }
    } on PlatformException catch (e) {
      Get.snackbar("Error", "${e.message}");
    }
    notifyListeners();
  }

  final int _musicNoteTurns = 1000;
  int get musicNoteTurns => _musicNoteTurns;
  @override
  notifyListeners();

  void togglePlayer(String path) {
    if (isPlaying) {
      pauseMusic();
      _isPlaying = false;
    } else {
      resumeMusic();
      _isPlaying = true;
    }
    notifyListeners();
  }

  bool _isAssetPlaying = false;
  bool get isAssetPlaying => _isAssetPlaying;
  final AudioPlayer _audioPlayer = AudioPlayer();
  void toggleAssetPlaying() async {
    await _audioPlayer.setSource(
      AssetSource('./music/सुरेशको जीवनको कथा.mp3'),
    );
    if (_isAssetPlaying) {
      _isAssetPlaying = false;
      await _audioPlayer.pause();
    } else {
      stopMusic();
      _isPlaying = false;
      _isAssetPlaying = true;
      await _audioPlayer.resume();
    }
    notifyListeners();
  }

  void stopAssetPlaying() {
    _audioPlayer.pause();
    _isAssetPlaying = false;
    notifyListeners();
  }
}
