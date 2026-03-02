import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/scene_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../player/providers/atmospheric_engine_provider.dart';

class MixerScreen extends ConsumerWidget {
  const MixerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineState = ref.watch(atmosphericEngineProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppTheme.softWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sound Mixer',
          style: TextStyle(
            color: AppTheme.warmCream,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Create your perfect blend',
            style: TextStyle(
              color: AppTheme.mutedGray,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          if (engineState.audioTracks.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  'No audio tracks playing right now.',
                  style: TextStyle(color: AppTheme.mutedGray, fontSize: 16),
                ),
              ),
            )
          else
            ...engineState.audioTracks.map((track) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: _buildMixerTrack(context, ref, track),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildMixerTrack(
      BuildContext context, WidgetRef ref, AudioTrack track) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(10)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(track.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  track.name,
                  style: const TextStyle(
                    color: AppTheme.warmCream,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                track.volume > 0
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                color:
                    track.volume > 0 ? AppTheme.amberGold : AppTheme.mutedGray,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.emberOrange,
              inactiveTrackColor: AppTheme.deepSlate,
              thumbColor: AppTheme.amberGold,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: track.volume,
              onChanged: (val) {
                ref
                    .read(atmosphericEngineProvider.notifier)
                    .setTrackVolume(track.id, val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
