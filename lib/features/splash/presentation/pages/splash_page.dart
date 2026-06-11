import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animasiya tənzimləmələri
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Animasiyanın müddəti
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Animasiyanı başladırıq
    _animationController.forward();

    // 2.5 saniyə gözləyib Ana Səhifəyə keçirik
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go('/main'); // MainPage-ə yönləndiririk
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Əgər loqonuz varsa, buraya Image.asset qoya bilərsiniz. 
              // Biz indilik estetik bir ikon və mətn qoyuruq.
              const Icon(
                Icons.movie_filter_rounded,
                size: 100,
                color: AppColors.primary, // Qırmızı Netflix rəngimiz
              ),
              const SizedBox(height: 16),
              Text(
                'KINOVA',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}