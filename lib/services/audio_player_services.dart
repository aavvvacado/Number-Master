// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AudioService {
//   AudioService._privateConstructor();
//   static final AudioService instance = AudioService._privateConstructor();

//   bool _isSfxEnabled = true;

//   bool get isSfxEnabled => _isSfxEnabled;

//   Future<void> loadPreferences() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       _isSfxEnabled = prefs.getBool('isSfxEnabled') ?? true;
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error loading audio preferences: $e");
//       }
//       _isSfxEnabled = true;
//     }
//   }

//   Future<void> toggleSfx() async {
//     _isSfxEnabled = !_isSfxEnabled;
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isSfxEnabled', _isSfxEnabled);
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error saving audio preferences: $e");
//       }
//     }
//   }

//   void playTapSound() {
//     if (!_isSfxEnabled) {
//       return;
//     }

//     final AudioPlayer player = AudioPlayer();

//     player.setPlayerMode(PlayerMode.lowLatency);
//     player.play(AssetSource('audio/button_click.mp3'), volume: 1.0);

//     player.onPlayerComplete.listen((event) {
//       player.dispose();
//     });
//   }

//   void playLevelUpSound() {
//     if (!_isSfxEnabled) {
//       return;
//     }

//     final AudioPlayer player = AudioPlayer();
//     player.setPlayerMode(PlayerMode.lowLatency);
//     player.play(AssetSource('audio/victory_cheer.mp3'), volume: 1.0);

//     player.onPlayerComplete.listen((event) {
//       player.dispose();
//     });
//   }

//   void dispose() {}
// }

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  AudioService._privateConstructor();
  static final AudioService instance = AudioService._privateConstructor();

  bool _isSfxEnabled = true;
  bool _isBgmEnabled = true;

  final AudioPlayer _bgmPlayer = AudioPlayer();

  bool get isSfxEnabled => _isSfxEnabled;
  bool get isBgmEnabled => _isBgmEnabled;

  Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isSfxEnabled = prefs.getBool('isSfxEnabled') ?? true;
      _isBgmEnabled = prefs.getBool('isBgmEnabled') ?? true;

      await _bgmPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

      if (_isBgmEnabled) {
        startBgm();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading audio preferences: $e");
      }
      _isSfxEnabled = true;
      _isBgmEnabled = true;
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
    if (!_isSfxEnabled) return;
    final AudioPlayer player = AudioPlayer();
    player.setPlayerMode(PlayerMode.lowLatency);
    player.play(AssetSource('audio/button_click.mp3'), volume: 1.0);
    player.onPlayerComplete.listen((event) {
      player.dispose();
    });
  }

  void playLevelUpSound() {
    if (!_isSfxEnabled) return;
    final AudioPlayer player = AudioPlayer();
    player.setPlayerMode(PlayerMode.lowLatency);
    player.play(AssetSource('audio/victory_cheer.mp3'), volume: 1.0);
    player.onPlayerComplete.listen((event) {
      player.dispose();
    });
  }

  Future<void> toggleBgm() async {
    _isBgmEnabled = !_isBgmEnabled;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isBgmEnabled', _isBgmEnabled);
    } catch (e) {
      if (kDebugMode) {
        print("Error saving audio preferences: $e");
      }
    }

    if (_isBgmEnabled) {
      startBgm();
    } else {
      stopBgm();
    }
  }

  void startBgm() {
    if (_isBgmEnabled && _bgmPlayer.state != PlayerState.playing) {
      _bgmPlayer.play(AssetSource('audio/background_music.mp3'), volume: 0.5);
    }
  }

  void stopBgm() {
    _bgmPlayer.stop();
  }

  void dispose() {
    _bgmPlayer.dispose();
  }
}
