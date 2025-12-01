import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Video player widget with custom controls optimized for exercise viewing
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool isPlaying;
  final VoidCallback onPlayPauseToggle;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.isPlaying,
    required this.onPlayPauseToggle,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _showControls = true;
  double _volume = 0.8;
  bool _isMuted = false;

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  // ignore: unused_element
  void _adjustVolume(double value) {
    setState(() {
      _volume = value;
      if (_volume > 0) {
        _isMuted = false;
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _toggleControls,
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video placeholder with thumbnail
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageWidget(
                    imageUrl:
                        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
                    width: 80.w,
                    height: 40.h,
                    fit: BoxFit.cover,
                    semanticLabel:
                        'Exercise demonstration video showing proper form and technique for motor reactivation movements',
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Video Player Integration',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'YouTube/Cloud video will play here',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Video controls overlay
            if (_showControls)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top controls
                    Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Volume control
                          IconButton(
                            icon: CustomIconWidget(
                              iconName: _isMuted ? 'volume_off' : 'volume_up',
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: _toggleMute,
                          ),
                        ],
                      ),
                    ),

                    // Center play/pause button
                    Center(
                      child: Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: CustomIconWidget(
                            iconName: widget.isPlaying ? 'pause' : 'play_arrow',
                            color: Colors.white,
                            size: 8.w,
                          ),
                          onPressed: widget.onPlayPauseToggle,
                        ),
                      ),
                    ),

                    // Bottom controls
                    Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        children: [
                          // Progress bar
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 1.h),

                          // Control buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Skip backward 10s
                              IconButton(
                                icon: CustomIconWidget(
                                  iconName: 'replay_10',
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {},
                              ),

                              // Skip forward 10s
                              IconButton(
                                icon: CustomIconWidget(
                                  iconName: 'forward_10',
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {},
                              ),

                              // Fullscreen toggle
                              IconButton(
                                icon: CustomIconWidget(
                                  iconName: 'fullscreen',
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
