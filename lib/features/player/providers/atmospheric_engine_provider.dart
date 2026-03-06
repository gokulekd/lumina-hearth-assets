import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/scene_data.dart';
import '../services/audio_mixer_service.dart';
import 'scene_config_provider.dart';

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

String _mapSceneIdToString(SceneId id) {
  switch (id) {
    case SceneId.classicHearth:
      return 'classic_hearth';
    case SceneId.midnightForest:
      return 'rain_forest';
    case SceneId.coastalBreeze:
      return 'river_side';
    case SceneId.zenGarden:
      return 'tibet_temple';
    case SceneId.rainyCafe:
      return 'hut_in_rain';
    case SceneId.himalayanCabin:
      return 'himalayan_cabin';
    default:
      return 'classic_hearth'; // Fallback
  }
}

List<AudioTrack> _tracksForScene(
    SceneId id, Map<String, dynamic> remoteConfig) {
  final stringId = _mapSceneIdToString(id);

  if (remoteConfig.containsKey(stringId)) {
    return List<AudioTrack>.from(remoteConfig[stringId]['tracks']);
  }

  // Fallback to local configs
  switch (id) {
    case SceneId.classicHearth:
      return SceneData.hearth();
    case SceneId.midnightForest:
      return SceneData.forest();
    case SceneId.himalayanCabin:
      return SceneData.cabin();
    case SceneId.coastalBreeze:
      return SceneData.coastal();
    default:
      return [];
  }
}

class AtmosphericEngineNotifier extends StateNotifier<SceneState> {
  final AudioMixerService _audioMixer;
  final Map<String, dynamic> _remoteConfig;

  AtmosphericEngineNotifier({
    required AudioMixerService audioMixer,
    required Map<String, dynamic> remoteConfig,
  })  : _audioMixer = audioMixer,
        _remoteConfig = remoteConfig,
        super(
          SceneState(
            scene: SceneData.all.first,
            audioTracks: _tracksForScene(SceneData.all.first.id, remoteConfig),
          ),
        ) {
    // Load initial scene
    _audioMixer
        .loadScene(
      state.audioTracks,
      masterVolume: state.masterVolume,
    )
        .then((_) {
      if (mounted && state.isPlaying) {
        _audioMixer.playAll();
      }
    });
  }

  void selectScene(SceneDefinition scene) {
    final tracks = _tracksForScene(scene.id, _remoteConfig);
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
    final remoteConfigAsync = ref.watch(remoteSceneConfigProvider);

    // Pass empty map or the loaded remote config map
    final configMap = remoteConfigAsync.valueOrNull ?? {};

    return AtmosphericEngineNotifier(
      audioMixer: mixer,
      remoteConfig: configMap,
    );
  },
);
