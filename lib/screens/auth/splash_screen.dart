import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onNavigateHome;
  final VoidCallback onNavigateLogin;

  final String appName;
  final String appSubtitle;
  final String tagline;
  final String taglineHighlight;
  final String poweredByText;

  final int minimumSplashMs;

  const SplashScreen({
    super.key,
    required this.onNavigateHome,
    required this.onNavigateLogin,
    this.appName = 'FuturePath',
    this.appSubtitle = 'EMPLOYMENT HUB',
    this.tagline = 'Building Skills.',
    this.taglineHighlight = 'Creating Opportunities.',
    this.poweredByText =
    'Powered by Department of Labour & Employment',
    this.minimumSplashMs = 3000,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;
  Timer? _dotTimer;

  int _activeDot = 0;

  @override
  void initState() {
    super.initState();

    _dotTimer = Timer.periodic(
      const Duration(milliseconds: 400),
          (_) {
        if (!mounted) return;

        setState(() {
          _activeDot = (_activeDot + 1) % 3;
        });
      },
    );

    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();

    final hasSession =
        prefs.getString('session_token') != null;

    _navigationTimer = Timer(
      Duration(milliseconds: widget.minimumSplashMs),
          () {
        if (!mounted) return;

        if (hasSession) {
          widget.onNavigateHome();
        } else {
          widget.onNavigateLogin();
        }
      },
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _dotTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _AppIconWidget(),

                const SizedBox(height: 24),

                Text(
                  widget.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  widget.appSubtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  widget.tagline,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),

                Text(
                  widget.taglineHighlight,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                _DotsIndicator(
                  activeDot: _activeDot,
                ),

                const SizedBox(height: 24),

                Text(
                  widget.poweredByText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppIconWidget extends StatelessWidget {
  const _AppIconWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Icon(
        Icons.work_outline,
        size: 60,
        color: Colors.blue,
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int activeDot;

  const _DotsIndicator({
    required this.activeDot,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
            (index) {
          return AnimatedContainer(
            duration: const Duration(
              milliseconds: 250,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            width: index == activeDot ? 12 : 10,
            height: index == activeDot ? 12 : 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == activeDot
                  ? Colors.white
                  : Colors.white38,
            ),
          );
        },
      ),
    );
  }
}