import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.75),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 5),
                Text(
                  '  Build',
                  style: GoogleFonts.inconsolata(
                    fontSize: 77,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '  healthy',
                  style: GoogleFonts.inconsolata(
                    fontSize: 77,
                    fontWeight: FontWeight.w500,
                    color: Colors.teal,
                  ),
                ),
                Text(
                  '  habits',
                  style: GoogleFonts.inconsolata(
                    fontSize: 77,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(flex: 2),
                Center(
                  child: Text(
                    'Tecnologia que ',
                    style: GoogleFonts.inconsolata(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      shadows: List.generate(
                        10,
                        (index) => const Shadow(
                          offset: Offset(1.0, 2.0),
                          blurRadius: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'acompanha o seu ritmo',
                    style: GoogleFonts.inconsolata(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      shadows: List.generate(
                        10,
                        (index) => const Shadow(
                          offset: Offset(1.0, 2.0),
                          blurRadius: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
