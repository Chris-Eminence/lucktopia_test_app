import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucktopia/bottom_nav.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Stack(
          children: [
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text('Play and Win!', style: GoogleFonts.nunito(fontSize: 34, fontWeight: FontWeight.w900)),
                  Text('Game for everyone who likes to try', style: GoogleFonts.nunito(fontSize: 20, )),
                  Text('luck at guessing numbers', style: GoogleFonts.nunito(fontSize: 20, )),
                  Image.asset('assets/welcome_image.png'),
                ],
              ),
            ),

            Positioned(
                left: 0,
                right: 0,
                bottom: 50,
                child: InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text('Play game', textAlign: TextAlign.center, style: GoogleFonts.nunito(color: Colors.white),),
                              ),
                ))

          ],
        ),
    );
  }
}
