import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';

class MixerScreen extends ConsumerWidget {
  const MixerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          _buildMixerTrack('🔥', 'Crackling Fire', 0.8),
          const SizedBox(height: 24),
          _buildMixerTrack('🌬️', 'Gentle Wind', 0.4),
          const SizedBox(height: 24),
          _buildMixerTrack('🌧️', 'Light Rain', 0.2),
          const SizedBox(height: 24),
          _buildMixerTrack('🦉', 'Night Owl', 0.0),
        ],
      ),
    );
  }

  Widget _buildMixerTrack(String emoji, String name, double initialValue) {
    return StatefulBuilder(
      builder: (context, setState) {
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
                  Text(emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppTheme.warmCream,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    initialValue > 0
                        ? Icons.volume_up_rounded
                        : Icons.volume_off_rounded,
                    color: AppTheme.mutedGray,
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
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8),
                ),
                child: Slider(
                  value: initialValue,
                  onChanged: (val) {
                    setState(() {
                      initialValue = val;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
