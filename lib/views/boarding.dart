import 'package:flutter/material.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/services/storage.dart';
import 'package:moveness/shared/intro.dart';
import 'package:moveness/shared/intro_slide.dart';
import 'package:moveness/views/login.dart';

class BoardingView extends StatelessWidget {
  final storage = locator<StorageService>();

  @override
  Widget build(BuildContext context) {
    final List<IntroSlide> list = [
      IntroSlide(
        title: 'Registrera',
        subTitle: 'Registrera alla dina aktiviteter i appen.',
        imageUrl: 'assets/images/logo_white.png',
        backgroundColor: Theme.of(context).accentColor,
        textColor: Theme.of(context).primaryColor,
      ),
      IntroSlide(
        title: 'Tävla',
        subTitle: 'Sök och utmana andra användare eller team.',
        imageUrl: 'assets/images/logo_white.png',
        backgroundColor: Theme.of(context).primaryColorDark,
        textColor: Colors.white,
      ),
      IntroSlide(
        title: 'Vinn',
        subTitle: 'Efter två veckor vinner den eller de med flest '
            'aktivitetspoäng.',
        imageUrl: 'assets/images/logo_white.png',
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Theme.of(context).accentColor,
      ),
    ];

    return Intro(
      introductionList: list,
      onTapSkipButton: () {
        //Don't need to await since we wont read until next restart
        storage.writeFirstTime(false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return LoginView();
            },
          ),
        );
      },
    );
  }
}
