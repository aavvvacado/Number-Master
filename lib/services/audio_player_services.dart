

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  AudioService._privateConstructor();
  static final AudioService instance = AudioService._privateConstructor();

  bool _isSfxEnabled = true;

  bool get isSfxEnabled => _isSfxEnabled;

  Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isSfxEnabled = prefs.getBool('isSfxEnabled') ?? true;
    } catch (e) {
      if (kDebugMode) {
        print("Error loading audio preferences: $e");
      }
      _isSfxEnabled = true;
    }
  }

  Future<void> toggleSfx() async {
    _isSfxEnabled = !_isSfxEnabled;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSfxEnabled', _isSfxEnabled);
    } catch (e) {
      if (kDebugMode) {
        print("Error saving audio preferences: $e");
      }
    }
  }

  void playTapSound() {
    if (!_isSfxEnabled) {
      return;
    }

    final AudioPlayer player = AudioPlayer();

    player.setPlayerMode(PlayerMode.lowLatency);
    player.play(AssetSource('audio/button_click.mp3'), volume: 1.0);

    player.onPlayerComplete.listen((event) {
      player.dispose();
    });
  }

  void playLevelUpSound() {
    if (!_isSfxEnabled) {
      return;
    }

    final AudioPlayer player = AudioPlayer();
    player.setPlayerMode(PlayerMode.lowLatency);
    player.play(AssetSource('audio/victory_cheer.mp3'), volume: 1.0);

    player.onPlayerComplete.listen((event) {
      player.dispose();
    });
  }

  void dispose() {}
}
