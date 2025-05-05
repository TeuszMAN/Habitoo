import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  final Uri _url = Uri.parse(
    'https://www.adventistas.org/pt/saude/8-remedios-naturais/',
  );

  void _launchURL() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Não foi possível abrir $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habitoo'),
        backgroundColor: null,
        foregroundColor: null,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/splash2.png',
            opacity: AlwaysStoppedAnimation(0.8),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '8 REMÉDIOS NATURAIS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: null,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 350,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(36, 0, 150, 135),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: null,
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/images/oitoremedios.png'),

                      SizedBox(height: 60),
                      ElevatedButton(
                        onPressed: _launchURL,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: null,
                          foregroundColor: null,
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('SAIBA MAIS'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
