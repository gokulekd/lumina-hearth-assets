import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/scene_data.dart';
import '../services/audio_mixer_service.dart';

/// State for the currently active scene
class SceneState {
  final SceneDefinition scene;
  final bool isPlaying;
  final double masterVolume;
  final List<AudioTrack> audioTracks;

  const SceneState({
    required this.scene,
    this.isPlaying = true,
    this.masterVolume = 1.0,
    required this.audioTracks,
  });

  SceneState copyWith({
    SceneDefinition? scene,
    bool? isPlaying,
    double? masterVolume,
    List<AudioTrack>? audioTracks,
  }) {
    return SceneState(
      scene: scene ?? this.scene,
      isPlaying: isPlaying ?? this.isPlaying,
      masterVolume: masterVolume ?? this.masterVolume,
      audioTracks: audioTracks ?? this.audioTracks,
    );
  }
}

List<AudioTrack> _tracksForScene(SceneId id) {
  switch (id) {
    case SceneId.classicHearth:
      return SceneData.hearth();
    case SceneId.midnightForest:
      return SceneData.forest();
    case SceneId.himalayanCabin:
      return SceneData.cabin();
    case SceneId.coastalBreeze:
      return SceneData.coastal();
    case SceneId.zenGarden:
    case SceneId.deepSpace:
    case SceneId.rainyCafe:
    case SceneId.autumnBreeze:
    case SceneId.crystalCave:
    case SceneId.cherryBlossom:
    case SceneId.underwaterReef:
    case SceneId.desertNight:
      return [];
  }
}

class AtmosphericEngineNotifier extends StateNotifier<SceneState> {
  final AudioMixerService _audioMixer;

  AtmosphericEngineNotifier({required AudioMixerService audioMixer})
      : _audioMixer = audioMixer,
        super(
          SceneState(
            scene: SceneData.all.first,
            audioTracks: _tracksForScene(SceneId.classicHearth),
          ),
        ) {
    // Load initial scene
    _audioMixer
        .loadScene(
      state.audioTracks,
      masterVolume: state.masterVolume,
    )
        .then((_) {
      if (state.isPlaying) {
        _audioMixer.playAll();
      }
    });
  }

  void selectScene(SceneDefinition scene) {
    final tracks = _tracksForScene(scene.id);
    state = state.copyWith(
      scene: scene,
      audioTracks: tracks,
      isPlaying: true,
    );
    _audioMixer.loadScene(tracks, masterVolume: state.masterVolume).then((_) {
      _audioMixer.playAll();
    });
  }

  void togglePlayPause() {
    final isPlaying = !state.isPlaying;
    state = state.copyWith(isPlaying: isPlaying);

    if (isPlaying) {
      _audioMixer.playAll();
    } else {
      _audioMixer.pauseAll();
    }
  }

  void pause() {
    if (state.isPlaying) {
      state = state.copyWith(isPlaying: false);
      _audioMixer.pauseAll();
    }
  }

  void setMasterVolume(double volume) {
    final clamped = volume.clamp(0.0, 1.0);
    state = state.copyWith(masterVolume: clamped);
    _audioMixer.setMasterVolume(clamped);
  }

  void setTrackVolume(String trackId, double volume) {
    final clamped = volume.clamp(0.0, 1.0);

    // Update State
    final updatedTracks = state.audioTracks.map((track) {
      if (track.id == trackId) {
        return track.copyWith(volume: clamped);
      }
      return track;
    }).toList();
    state = state.copyWith(audioTracks: updatedTracks);

    // Update Audio mix
    _audioMixer.setTrackVolume(trackId, clamped);
  }

  @override
  void dispose() {
    _audioMixer.dispose();
    super.dispose();
  }
}

final audioMixerProvider = Provider<AudioMixerService>((ref) {
  final service = AudioMixerService();
  ref.onDispose(() => service.dispose());
  return service;
});

final atmosphericEngineProvider =
    StateNotifierProvider<AtmosphericEngineNotifier, SceneState>(
  (ref) {
    final mixer = ref.watch(audioMixerProvider);
    return AtmosphericEngineNotifier(audioMixer: mixer);
  },
);
