import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';

/// Animated horizontal journey timeline widget
///
/// Displays a 60-day journey with 4 milestones (Start, Week 4, Week 8, Week 12)
/// Features:
/// - Animated progress line filling from Start → Week 12
/// - Moving praying person icon along the progress line
/// - Milestone dots (filled when completed, outlined when upcoming)
/// - Responsive layout for web and mobile
class JourneyTimeline extends StatefulWidget {
  const JourneyTimeline({
    required this.currentWeek,
    this.duration = const Duration(milliseconds: 1500),
    this.activeColor,
    this.inactiveColor,
    this.showTitle = true,
    this.title = 'Your 60-Day Journey',
    this.subtitle,
    super.key,
  });

  // Fixed milestone weeks and their progress fractions
  static const List<int> milestoneWeeks = [0, 4, 8, 12];
  static const List<double> milestoneFractions = [0.0, 1 / 3, 2 / 3, 1.0];
  static const List<String> milestoneLabels = [
    'Start',
    'Week 4',
    'Week 8',
    'Week 12',
  ];

  /// Current week (0-12)
  final int currentWeek;

  /// Animation duration
  final Duration duration;

  /// Color for active/completed milestones and progress line
  final Color? activeColor;

  /// Color for inactive milestones and base line
  final Color? inactiveColor;

  /// Whether to show title and subtitle
  final bool showTitle;

  /// Title text
  final String title;

  /// Subtitle text (optional)
  final String? subtitle;

  @override
  State<JourneyTimeline> createState() => _JourneyTimelineState();
}

class _JourneyTimelineState extends State<JourneyTimeline>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Calculate initial progress and animate from 0
    final initialProgress = _calculateProgress(widget.currentWeek);
    _controller.value = 0;
    
    // Trigger initial animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.animateTo(
          initialProgress,
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void didUpdateWidget(JourneyTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentWeek != widget.currentWeek) {
      final newProgress = _calculateProgress(widget.currentWeek);
      _controller.animateTo(
        newProgress,
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateProgress(int week) {
    // Clamp week to 0-12 range
    final clampedWeek = week.clamp(0, 12);
    return clampedWeek / 12.0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = widget.activeColor ?? colorScheme.primary;
    final inactiveColor = widget.inactiveColor ??
        colorScheme.outline.withValues(alpha: 0.3);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showTitle) ...[
              Text(
                widget.title,
                style: AppTypography.h2(
                  color: colorScheme.onSurface,
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.subtitle!,
                  style: AppTypography.body(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
            LayoutBuilder(
              builder: (context, constraints) {
                return _TimelinePainterWidget(
                  controller: _controller,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  colorScheme: colorScheme,
                  width: constraints.maxWidth,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelinePainterWidget extends AnimatedWidget {
  const _TimelinePainterWidget({
    required this.controller,
    required this.activeColor,
    required this.inactiveColor,
    required this.colorScheme,
    required this.width,
  }) : super(listenable: controller);

  final AnimationController controller;
  final Color activeColor;
  final Color inactiveColor;
  final ColorScheme colorScheme;
  final double width;

  @override
  Widget build(BuildContext context) {
    final progress = controller.value;

    // Calculate horizontal positions
    // Leave padding for icon and dots
    const horizontalPadding = 24.0;
    const iconSize = 40.0;
    const dotRadius = 8.0;
    final startX = horizontalPadding + iconSize / 2;
    final endX = width - horizontalPadding - iconSize / 2;
    final lineLength = endX - startX;

    // Calculate milestone positions
    final milestonePositions = JourneyTimeline.milestoneFractions
        .map((fraction) => startX + (lineLength * fraction))
        .toList(growable: false);

    // Calculate icon position (moving along the line)
    final iconX = startX + (lineLength * progress);

    return SizedBox(
      height: 120, // Fixed height for timeline
      child: Stack(
        children: [
          // Base line and progress line (drawn with CustomPaint)
          CustomPaint(
            size: Size(width, 120),
            painter: _TimelinePainter(
              progress: progress,
              startX: startX,
              endX: endX,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              milestonePositions: milestonePositions,
            ),
          ),

          // Milestone dots
          ...JourneyTimeline.milestoneFractions.asMap().entries.map(
                (entry) {
                  final index = entry.key;
                  final fraction = entry.value;
                  final isActive = progress >= fraction;
                  final dotX = milestonePositions[index];

                  return Positioned(
                    left: dotX - dotRadius,
                    top: 40 - dotRadius, // Center dot on line
                    child: _MilestoneDot(
                      isActive: isActive,
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      colorScheme: colorScheme,
                    ),
                  );
                },
              ),

          // Moving praying person icon
          Positioned(
            left: iconX - iconSize / 2,
            top: 40 - iconSize / 2, // Center icon on line
            child: _PrayingIcon(
              color: activeColor,
              size: iconSize,
            ),
          ),

          // Milestone labels - positioned under each dot
          ...JourneyTimeline.milestoneLabels.asMap().entries.map(
                (entry) {
                  final index = entry.key;
                  final label = entry.value;
                  final dotX = milestonePositions[index];

                  return Positioned(
                    left: dotX - 40, // Center label under dot (half of 80px width)
                    top: 60, // Below the line
                    width: 80,
                    child: Text(
                      label,
                      style: AppTypography.caption(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  _TimelinePainter({
    required this.progress,
    required this.startX,
    required this.endX,
    required this.activeColor,
    required this.inactiveColor,
    required this.milestonePositions,
  });

  final double progress;
  final double startX;
  final double endX;
  final Color activeColor;
  final Color inactiveColor;
  final List<double> milestonePositions;

  @override
  void paint(Canvas canvas, Size size) {
    const lineY = 40.0;
    const lineStrokeWidth = 2.0;

    // Draw base line (inactive)
    final baseLinePaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = lineStrokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(startX, lineY),
      Offset(endX, lineY),
      baseLinePaint,
    );

    // Draw progress line (active)
    if (progress > 0) {
      final progressEndX = startX + ((endX - startX) * progress);
      final progressLinePaint = Paint()
        ..color = activeColor
        ..strokeWidth = lineStrokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(startX, lineY),
        Offset(progressEndX, lineY),
        progressLinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_TimelinePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.startX != startX ||
        oldDelegate.endX != endX;
  }
}

class _MilestoneDot extends StatelessWidget {
  const _MilestoneDot({
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.colorScheme,
  });

  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    const dotRadius = 8.0;

    return Container(
      width: dotRadius * 2,
      height: dotRadius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? activeColor : colorScheme.surface,
        border: Border.all(
          color: isActive ? activeColor : inactiveColor,
          width: 2,
        ),
      ),
    );
  }
}

class _PrayingIcon extends StatelessWidget {
  const _PrayingIcon({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.self_improvement,
        color: color,
        size: size * 0.6,
      ),
    );
  }
}
