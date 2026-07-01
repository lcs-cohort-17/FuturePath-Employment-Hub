import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart';

class SplashScreen extends StatefulWidget {
  /// Navigation callback — called when a valid session is found.
  final VoidCallback onNavigateHome;

  /// Navigation callback — called when no session exists.
  final VoidCallback onNavigateLogin;

  /// REPLACE THIS when Auth team injects the real session flag.
  /// Currently defaults to false (no session) for safe demo behaviour.
  final bool isLoggedIn;

  /// Display strings — swap with constants or remote config as needed.
  final String appName;
  final String appSubtitle;
  final String tagline;
  final String taglineHighlight;
  final String poweredByText;

  /// Minimum time (ms) the splash is visible — prevents flash on fast devices.
  final int minimumSplashMs;

  const SplashScreen({
    super.key,
    required this.onNavigateHome,
    required this.onNavigateLogin,
    this.isLoggedIn = false, // ← Auth team replaces with real value
    this.appName = 'FuturePath',
    this.appSubtitle = 'EMPLOYMENT HUB',
    this.tagline = 'Building Skills. ',
    this.taglineHighlight = 'Creating Opportunities.',
    this.poweredByText = 'Powered by Department of Labour & Employment',
    this.minimumSplashMs = 1500,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // ----------------------------------------------------------
  // Animation controllers
  // ----------------------------------------------------------
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Dots loading indicator state
  int _activeDot = 0;
  late Stream<int> _dotStream;

  @override
  void initState() {
    // ── Animation setup ──────────────────────────────────────
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();

    // ── Dot pulse stream ─────────────────────────────────────
    _dotStream = Stream.periodic(
      const Duration(milliseconds: 400),
          (tick) => tick % 3,
    );

    _dotStream.listen((dot) {
      if (mounted) setState(() => _activeDot = dot);
    });

    // ── Auth check + minimum display time ────────────────────
    // INTEGRATION POINT: replace `widget.isLoggedIn` with the
    // real SharedPreferences / Supabase session lookup.
    // e.g.:
    //   final prefs = await SharedPreferences.getInstance();
    //   final hasSession = prefs.getString('session_token') != null;
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Enforce minimum display time alongside any async work.
    final minimumWait = Future<void>.delayed(
      Duration(milliseconds: widget.minimumSplashMs),
    );

    // Use the real Supabase session check from AuthService
    final bool hasSession = AuthService().isLoggedIn;

    // Ensure minimum splash time has elapsed regardless of check speed.
    await minimumWait;

    if (!mounted) return;

    if (hasSession) {
      widget.onNavigateHome();
    } else {
      widget.onNavigateLogin();
    }
  }

  @override
  void dispose() {
    // ── Clean up animation controller to prevent memory leaks ──
    _fadeController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // Build
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // ── Top section: logo + wordmark + tagline ──────
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: _AppIconWidget(),
                    ),
                    const SizedBox(height: 20),
                    _WordmarkWidget(
                      appName: widget.appName,
                      appSubtitle: widget.appSubtitle,
                    ),
                    const SizedBox(height: 28),
                    _TaglineWidget(
                      tagline: widget.tagline,
                      highlight: widget.taglineHighlight,
                    ),
                  ],
                ),
              ),

              // ── Centre section: bar chart illustration ───────
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: _BarChartIllustration(),
                ),
              ),

              // ── Bottom section: dots + powered-by ────────────
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _DotsIndicator(activeDot: _activeDot),
                    const SizedBox(height: 20),
                    _PoweredByWidget(text: widget.poweredByText),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Sub-widgets (private, file-scoped)
// ============================================================

class _AppIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDim],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.trending_up_rounded,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}

class _WordmarkWidget extends StatelessWidget {
  final String appName;
  final String appSubtitle;

  const _WordmarkWidget({
    required this.appName,
    required this.appSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          appName,
          style: const TextStyle(
            color: AppTheme.textDark,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          appSubtitle,
          style: const TextStyle(
            color: AppTheme.mutedText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.5,
          ),
        ),
      ],
    );
  }
}

class _TaglineWidget extends StatelessWidget {
  final String tagline;
  final String highlight;

  const _TaglineWidget({
    required this.tagline,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: tagline,
            style: const TextStyle(
              color: AppTheme.mutedText,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: highlight,
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChartIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarChartPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final barFractions = [0.30, 0.42, 0.55, 0.65, 0.50, 0.72, 0.80, 0.68, 0.75];
    final barCount = barFractions.length;
    final barWidth = (size.width - (barCount - 1) * 8) / barCount;

    final barPaint = Paint()
      ..color = AppTheme.primaryDim
      ..style = PaintingStyle.fill;

    for (int i = 0; i < barCount; i++) {
      final left = i * (barWidth + 8);
      final barHeight = size.height * barFractions[i];
      final top = size.height - barHeight;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, barHeight),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, barPaint);
    }

    final baselinePaint = Paint()
      ..color = AppTheme.border2
      ..strokeWidth = 0.5;
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      baselinePaint,
    );

    final dotFractions = [0, 2, 4, 6, 7];
    final linePaint = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.fill;

    final trendPoints = dotFractions.map((i) {
      final cx = i * (barWidth + 8) + barWidth / 2;
      final cy = size.height - size.height * barFractions[i];
      return Offset(cx, cy);
    }).toList();

    for (int i = 0; i < trendPoints.length - 1; i++) {
      canvas.drawLine(trendPoints[i], trendPoints[i + 1], linePaint);
    }

    for (final pt in trendPoints) {
      canvas.drawCircle(pt, 4.5, dotPaint);
      canvas.drawCircle(
        pt,
        4.5,
        Paint()
          ..color = AppTheme.border2
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    final arrowTip = trendPoints.last + const Offset(26, -26);
    final arrowBase = trendPoints.last + const Offset(4, -4);
    final arrowPaint = Paint()
      ..color = AppTheme.mutedText
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(arrowBase, arrowTip, arrowPaint);

    final headPaint = Paint()
      ..color = AppTheme.mutedText
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(arrowTip.dx, arrowTip.dy)
      ..lineTo(arrowTip.dx - 9, arrowTip.dy + 2)
      ..lineTo(arrowTip.dx - 2, arrowTip.dy + 9)
      ..close();
    canvas.drawPath(path, headPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DotsIndicator extends StatelessWidget {
  final int activeDot;

  const _DotsIndicator({required this.activeDot});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isActive = i == activeDot;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: isActive ? 10 : 7,
          height: isActive ? 10 : 7,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppTheme.primary : AppTheme.primaryLow,
          ),
        );
      }),
    );
  }
}

class _PoweredByWidget extends StatelessWidget {
  final String text;

  const _PoweredByWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppTheme.subtleText,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
      ),
    );
  }
}