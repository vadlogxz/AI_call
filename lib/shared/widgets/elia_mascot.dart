import 'dart:math' as math;

import 'package:flutter/material.dart';

enum MascotState { idle, speaking, thinking }

/// Animated owl mascot with three colour themes:
/// - idle     → blue
/// - speaking → green
/// - thinking → amber
class EliaMascot extends StatefulWidget {
  const EliaMascot({
    super.key,
    this.state = MascotState.idle,
    this.size = 120.0,
    this.showRings = false,
  });

  final MascotState state;
  final double size;

  /// Show concentric pulsing rings around the mascot (use when speaking).
  final bool showRings;

  @override
  State<EliaMascot> createState() => _EliaMascotState();
}

class _EliaMascotState extends State<EliaMascot>
    with TickerProviderStateMixin {
  late final AnimationController _float;
  late final AnimationController _blink;
  late final AnimationController _ring;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);

    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();

    _ring = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _float.dispose();
    _blink.dispose();
    _ring.dispose();
    super.dispose();
  }

  /// Returns 0..1 blink progress (1 = fully closed).
  double get _blinkProgress {
    final t = _blink.value;
    // Close eyes between 92 % and 98 % of the cycle.
    if (t >= 0.92 && t <= 0.98) {
      final mid = 0.95;
      return t < mid
          ? (t - 0.92) / (mid - 0.92)
          : (0.98 - t) / (0.98 - mid);
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_float, _blink, _ring]),
      builder: (context, _) {
        final floatY = math.sin(_float.value * math.pi) * 5.0;
        final colors = _MascotColors.forState(widget.state);

        return SizedBox(
          width: widget.size + 60,
          height: widget.size * 1.27 + 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.showRings) ...[
                _Ring(size: widget.size * 0.75, t: _ring.value, offset: 0, color: colors.glow),
                _Ring(size: widget.size * 0.92, t: _ring.value, offset: 0.4, color: colors.glow),
                _Ring(size: widget.size * 1.10, t: _ring.value, offset: 0.8, color: colors.glow),
              ],
              Transform.translate(
                offset: Offset(0, floatY),
                child: CustomPaint(
                  size: Size(widget.size, widget.size * 1.27),
                  painter: _OwlPainter(
                    state: widget.state,
                    colors: colors,
                    blinkProgress: _blinkProgress.clamp(0.0, 1.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Ring helper ─────────────────────────────────────────────────────────────

class _Ring extends StatelessWidget {
  const _Ring({
    required this.size,
    required this.t,
    required this.offset,
    required this.color,
  });

  final double size;
  final double t;
  final double offset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final phase = (t + offset) % 1.0;
    return Opacity(
      opacity: ((1.0 - phase) * 0.45).clamp(0.0, 1.0),
      child: Transform.scale(
        scale: 0.78 + phase * 0.22,
        child: SizedBox(
          width: size,
          height: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Color themes ─────────────────────────────────────────────────────────────

class _MascotColors {
  const _MascotColors({
    required this.body,
    required this.bodyHighlight,
    required this.face,
    required this.belly,
    required this.iris,
    required this.glow,
    required this.brow,
    required this.branch,
  });

  final Color body;
  final Color bodyHighlight;
  final Color face;
  final Color belly;
  final Color iris;
  final Color glow;
  final Color brow;
  final Color branch;

  static _MascotColors forState(MascotState state) => switch (state) {
        MascotState.idle => const _MascotColors(
            body: Color(0xFF0c1640),
            bodyHighlight: Color(0xFF1a2e78),
            face: Color(0xFF1e3490),
            belly: Color(0xFF8aaaf0),
            iris: Color(0xFF3050d8),
            glow: Color(0xFF3a5cd8),
            brow: Color(0xFF7090f0),
            branch: Color(0xFF1a2248),
          ),
        MascotState.speaking => const _MascotColors(
            body: Color(0xFF081c10),
            bodyHighlight: Color(0xFF144028),
            face: Color(0xFF1a5030),
            belly: Color(0xFF50c880),
            iris: Color(0xFF28a858),
            glow: Color(0xFF40e870),
            brow: Color(0xFF50e890),
            branch: Color(0xFF142418),
          ),
        MascotState.thinking => const _MascotColors(
            body: Color(0xFF200e02),
            bodyHighlight: Color(0xFF4a2c08),
            face: Color(0xFF3a1e08),
            belly: Color(0xFFe8a840),
            iris: Color(0xFFc07820),
            glow: Color(0xFFd09030),
            brow: Color(0xFFe8a040),
            branch: Color(0xFF1a0e04),
          ),
      };
}

// ── Painter ──────────────────────────────────────────────────────────────────

class _OwlPainter extends CustomPainter {
  const _OwlPainter({
    required this.state,
    required this.colors,
    required this.blinkProgress,
  });

  final MascotState state;
  final _MascotColors colors;
  final double blinkProgress;

  // SVG source uses a 150 × 190 coordinate space.
  static const _svgW = 150.0;
  static const _svgH = 190.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / _svgW, size.height / _svgH);

    _drawBranch(canvas);
    _drawWings(canvas);
    _drawBody(canvas);
    _drawBelly(canvas);
    _drawEarTufts(canvas);
    _drawFaceDisc(canvas);
    _drawEyes(canvas);
    _drawBeak(canvas);
    if (state == MascotState.thinking) _drawThoughtBubble(canvas);

    canvas.restore();
  }

  // ── Branch + talons ────────────────────────────────────────────────────────

  void _drawBranch(Canvas canvas) {
    final dark = Paint()
      ..color = colors.branch
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final light = Paint()
      ..color = colors.branch.withValues(alpha: 1.6) // lighten
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final p = Path()
      ..moveTo(8, 168)
      ..quadraticBezierTo(40, 162, 75, 164)
      ..quadraticBezierTo(110, 162, 142, 168);

    canvas.drawPath(p, dark);
    canvas.drawPath(
      p,
      light
        ..color = Color.lerp(colors.branch, Colors.white, 0.15)!
        ..strokeWidth = 5,
    );

    final talon = Paint()
      ..color = colors.branch.withValues(alpha: 0.9)
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    _talons(canvas, talon, 55, 163);
    _talons(canvas, talon, 93, 163);
  }

  void _talons(Canvas canvas, Paint p, double cx, double cy) {
    for (final dx in [-7.0, 0.0, 7.0]) {
      canvas.drawLine(Offset(cx, cy), Offset(cx + dx * 0.6, cy + 12), p);
    }
  }

  // ── Wings ──────────────────────────────────────────────────────────────────

  void _drawWings(Canvas canvas) {
    final p = Paint()
      ..color = colors.body
      ..style = PaintingStyle.fill;

    // Left wing
    final left = Path()
      ..moveTo(30, 120)
      ..cubicTo(18, 108, 14, 90, 20, 75)
      ..cubicTo(26, 60, 38, 58, 46, 68)
      ..cubicTo(40, 80, 38, 100, 42, 118)
      ..close();
    canvas.drawPath(left, p);

    // Right wing
    final right = Path()
      ..moveTo(120, 120)
      ..cubicTo(132, 108, 136, 90, 130, 75)
      ..cubicTo(124, 60, 112, 58, 104, 68)
      ..cubicTo(110, 80, 112, 100, 108, 118)
      ..close();
    canvas.drawPath(right, p);

    // Wing feather lines
    final feather = Paint()
      ..color = colors.bodyHighlight
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = colors.bodyHighlight.withValues(alpha: 0.7);

    for (final y in [90.0, 100.0, 110.0]) {
      canvas.drawLine(Offset(22, y), Offset(44, y - 4), feather);
      canvas.drawLine(Offset(128, y), Offset(106, y - 4), feather);
    }
  }

  // ── Body ───────────────────────────────────────────────────────────────────

  void _drawBody(Canvas canvas) {
    final outer = Paint()
      ..color = colors.bodyHighlight
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(75, 110), width: 86, height: 126),
      outer,
    );
    final inner = Paint()
      ..color = colors.body
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(75, 116), width: 80, height: 112),
      inner,
    );
  }

  // ── Belly ──────────────────────────────────────────────────────────────────

  void _drawBelly(Canvas canvas) {
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(75, 118), width: 52, height: 64),
      Paint()
        ..color = colors.belly.withValues(alpha: 0.45)
        ..style = PaintingStyle.fill,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(75, 118), width: 36, height: 48),
      Paint()
        ..color = colors.belly.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill,
    );
  }

  // ── Ear tufts ──────────────────────────────────────────────────────────────

  void _drawEarTufts(Canvas canvas) {
    void tuft(
      double ax,
      double ay,
      double bx,
      double by,
      double cx,
      double cy,
      double dx,
      double dy,
      bool flip,
    ) {
      final outer = Path()
        ..moveTo(ax, ay)
        ..cubicTo(bx, by, cx, cy, dx, dy)
        ..close();
      canvas.drawPath(outer, Paint()..color = colors.body..style = PaintingStyle.fill);

      // Inner highlight
      final inner = Path()
        ..moveTo(ax + (flip ? -2 : 2), ay)
        ..cubicTo(
          bx + (flip ? -1 : 1),
          by + 2,
          cx,
          cy + 2,
          dx,
          dy,
        )
        ..close();
      canvas.drawPath(inner, Paint()..color = colors.face..style = PaintingStyle.fill);
    }

    // Left ear
    tuft(52, 52, 48, 38, 50, 26, 56, 22, false);
    // Right ear
    tuft(98, 52, 102, 38, 100, 26, 94, 22, true);
  }

  // ── Face disc ─────────────────────────────────────────────────────────────

  void _drawFaceDisc(Canvas canvas) {
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(75, 78), width: 60, height: 56),
      Paint()
        ..color = colors.face
        ..style = PaintingStyle.fill,
    );
  }

  // ── Eyes ──────────────────────────────────────────────────────────────────

  void _drawEyes(Canvas canvas) {
    for (final cx in [62.0, 88.0]) {
      const cy = 76.0;
      final pos = Offset(cx, cy);

      // Socket
      canvas.drawCircle(pos, 13, Paint()..color = const Color(0xFF0a1235));
      // White
      canvas.drawCircle(pos, 12, Paint()..color = const Color(0xFFd8e4ff));
      // Iris
      canvas.drawCircle(pos, 9, Paint()..color = colors.iris);
      // Pupil
      canvas.drawCircle(pos, 5.5, Paint()..color = const Color(0xFF040820));

      // Blink lid
      if (blinkProgress > 0) {
        final lidH = 12.5 * blinkProgress;
        canvas.drawOval(
          Rect.fromCenter(center: pos, width: 25, height: lidH * 2),
          Paint()..color = colors.face,
        );
      }

      // Shine
      canvas.drawCircle(
        Offset(cx - 2.8, cy - 3.2),
        2.4,
        Paint()..color = Colors.white.withValues(alpha: 0.95),
      );
      canvas.drawCircle(
        Offset(cx + 3.8, cy + 3.5),
        1.1,
        Paint()..color = Colors.white.withValues(alpha: 0.5),
      );
    }

    // Brows
    final browPaint = Paint()
      ..color = colors.brow
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (state == MascotState.thinking) {
      // Furrowed brows
      browPaint.strokeWidth = 1.8;
      final l = Path()
        ..moveTo(48, 63)
        ..cubicTo(53, 58, 58, 57, 63, 59);
      canvas.drawPath(l, browPaint);
      final r = Path()
        ..moveTo(87, 59)
        ..cubicTo(92, 57, 97, 58, 102, 63);
      canvas.drawPath(r, browPaint);
    } else {
      // Neutral brows
      final l = Path()
        ..moveTo(50, 63)
        ..quadraticBezierTo(59, 57, 68, 60);
      canvas.drawPath(l, browPaint);
      final r = Path()
        ..moveTo(82, 60)
        ..quadraticBezierTo(91, 57, 100, 63);
      canvas.drawPath(r, browPaint);
    }
  }

  // ── Beak ──────────────────────────────────────────────────────────────────

  void _drawBeak(Canvas canvas) {
    final beakTop = Path()
      ..moveTo(71, 87)
      ..lineTo(75, 96)
      ..lineTo(79, 87)
      ..quadraticBezierTo(75, 83, 71, 87)
      ..close();

    canvas.drawPath(
      beakTop,
      Paint()
        ..color = const Color(0xFFe8c060)
        ..style = PaintingStyle.fill,
    );

    // Ridge line
    canvas.drawPath(
      Path()
        ..moveTo(71, 87)
        ..lineTo(75, 91)
        ..lineTo(79, 87),
      Paint()
        ..color = const Color(0xFFc8a040)
        ..style = PaintingStyle.fill,
    );

    // Speaking: show tongue
    if (state == MascotState.speaking) {
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(75, 93), width: 8, height: 5),
        Paint()
          ..color = const Color(0xFFe05050).withValues(alpha: 0.8)
          ..style = PaintingStyle.fill,
      );
    }
  }

  // ── Thought bubble (thinking state) ───────────────────────────────────────

  void _drawThoughtBubble(Canvas canvas) {
    final p = Paint()
      ..color = colors.iris.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(112, 38), 3.5, p);
    canvas.drawCircle(const Offset(121, 27), 5.5, p);
    canvas.drawCircle(const Offset(131, 14), 7.5, p);

    // "?" inside biggest circle
    final qPaint = Paint()
      ..color = colors.brow
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final q = Path()
      ..moveTo(128, 9)
      ..quadraticBezierTo(132, 6, 133, 10)
      ..quadraticBezierTo(133, 14, 130, 15)
      ..lineTo(130, 17);
    canvas.drawPath(q, qPaint);
    canvas.drawCircle(
      const Offset(130, 19.5),
      1.1,
      Paint()
        ..color = colors.brow
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_OwlPainter old) =>
      old.state != state || old.blinkProgress != blinkProgress;
}
