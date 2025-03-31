import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_theme.dart';
import 'auth/user_role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  bool _showLogo = false;
  bool _showAppName = false;
  bool _showTagline = false;
  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Sequence the animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showLogo = true);
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showAppName = true);
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _showTagline = true);
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _showLoader = true);
    });

    // Navigate after delay
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const UserRoleSelectionScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background waves
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundWavePainter(
                animation: _waveController,
                waveColor: AppTheme.primaryColor.withOpacity(0.05),
              ),
            ),
          ),
          // Decorative circles
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 40,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.doctorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            )
                .animate(target: _showLogo ? 1 : 0)
                .scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut,
                    duration: 800.ms)
                .moveY(begin: 20, end: 0, duration: 800.ms),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            right: 60,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.patientColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            )
                .animate(target: _showLogo ? 1 : 0)
                .scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut,
                    duration: 800.ms,
                    delay: 200.ms)
                .moveY(begin: 20, end: 0, duration: 800.ms, delay: 200.ms),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            right: 40,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            )
                .animate(target: _showTagline ? 1 : 0)
                .scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut,
                    duration: 800.ms)
                .moveY(begin: 20, end: 0, duration: 800.ms),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                if (_showLogo) _buildLogo(),
                const SizedBox(height: 20),
                if (_showAppName) _buildAppName(),
                const SizedBox(height: 10),
                if (_showTagline) _buildTagline(),
                const Spacer(),
                if (_showLoader) _buildLoadingIndicator(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.medical_services_rounded,
          size: 64,
          color: AppTheme.primaryColor,
        )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2000.ms, delay: 1000.ms),
      ),
    )
        .animate()
        .scale(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
        )
        .fade(
          duration: const Duration(milliseconds: 500),
        );
  }

  Widget _buildAppName() {
    return Text(
      'DocPilot',
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
    )
        .animate()
        .fade(
          duration: const Duration(milliseconds: 600),
        )
        .slideY(
          duration: const Duration(milliseconds: 600),
          begin: 0.2,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildTagline() {
    return Text(
      'Connecting Patients & Doctors',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.secondaryTextColor,
          ),
    )
        .animate()
        .fade(
          duration: const Duration(milliseconds: 600),
        )
        .slideY(begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOut);
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        strokeWidth: 3,
      ),
    )
        .animate()
        .fade(
          duration: const Duration(milliseconds: 600),
        )
        .scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1.0, 1.0),
            duration: 400.ms,
            curve: Curves.easeOut);
  }
}

class BackgroundWavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color waveColor;

  BackgroundWavePainter({required this.animation, required this.waveColor})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final height = size.height;
    final width = size.width;

    // First wave
    path.moveTo(0, height * 0.7);

    for (int i = 0; i < width; i++) {
      path.lineTo(
          i.toDouble(),
          height * 0.7 +
              sin((i / width * 4 * pi) + animation.value * 2 * pi) * 20);
    }

    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();
    canvas.drawPath(path, paint);

    // Second wave
    final path2 = Path();
    path2.moveTo(0, height * 0.8);

    for (int i = 0; i < width; i++) {
      path2.lineTo(
          i.toDouble(),
          height * 0.8 +
              sin((i / width * 3 * pi) + animation.value * 2 * pi + 1) * 15);
    }

    path2.lineTo(width, height);
    path2.lineTo(0, height);
    path2.close();

    final paint2 = Paint()
      ..color = waveColor.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
