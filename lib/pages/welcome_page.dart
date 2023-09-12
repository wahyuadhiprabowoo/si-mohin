import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:simohin/pages/home_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    const pageDecoration = const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        bodyTextStyle: TextStyle(fontSize: 18, letterSpacing: 1),
        bodyPadding: EdgeInsets.all(8),
        contentMargin: EdgeInsets.all(8),
        imageFlex: 2);
    return Expanded(
      child: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: [
          // slide 1
          PageViewModel(
            title: "Tekanan Darah",
            body:
                "Pemantauan tekanan darah adalah cara penting untuk menilai kondisi kesehatan kardiovaskular seseorang.",
            image: Image.asset(
              'assets/images/blood_1.png',
              fit: BoxFit.cover,
              width: 450,
            ),
            decoration: pageDecoration,
          ),

          // slide 2
          PageViewModel(
            title: "Deteksi Dini",
            body:
                "Pengukuran tekanan darah bermanfaat untuk mendeteksi dini risiko hipertensi dan gangguan kardiovaskular..",
            image: Image.asset(
              'assets/images/blood_4.png',
              fit: BoxFit.cover,
              width: 450,
            ),
            decoration: pageDecoration,
          )
        ],
        // pengaturan tombol dibawah
        onDone: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage())),
        showNextButton: true,
        showSkipButton: false,
        showBackButton: false,
        showDoneButton: true,
        done: Text(
          "Mulai",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        back: Icon(Icons.arrow_back),
        skip: Text("Lewati"),
        next: Icon(Icons.arrow_forward),
        dotsDecorator: DotsDecorator(
          size: Size(10, 10),
          color: Colors.redAccent,
          activeSize: Size(22, 10),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24))),
        ),
      ),
    );
  }
}
