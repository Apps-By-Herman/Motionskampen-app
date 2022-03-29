import 'package:flutter/material.dart';
import 'package:moveness/shared/intro_slide.dart';

class Intro extends StatefulWidget {
  Intro({
    Key? key,
    required this.introductionList,
    required this.onTapSkipButton,
  }) : super(key: key);

  final List<IntroSlide> introductionList;
  final Function onTapSkipButton;

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: PageView(
                physics: ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: widget.introductionList,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: FlatButton(
                minWidth: 1, //Is needed to not get rendering problems
                onPressed: () {
                  widget.onTapSkipButton();
                },
                child: Text(
                  'Hoppa över',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: _nextWidget(),
            )
            //_buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _nextWidget() {
    return IconButton(
      onPressed: () {
        _currentPage != widget.introductionList.length - 1
            ? _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              )
            : widget.onTapSkipButton();
      },
      icon: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      ),
      iconSize: 42,
    );
  }
}
