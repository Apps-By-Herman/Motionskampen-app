import 'package:flutter/material.dart';
import 'package:moveness/shared/heading.dart';

class IntroSlide extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String subTitle;
  final Color backgroundColor;
  final Color textColor;

  IntroSlide({
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  State<StatefulWidget> createState() {
    return new IntroSlideState();
  }
}

class IntroSlideState extends State<IntroSlide> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(color: widget.backgroundColor),
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(
                image: AssetImage(widget.imageUrl),
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Heading(
                  widget.title,
                  widget.textColor,
                )
              ],
            ),
            SizedBox(height: 4),
            Center(
              child: Text(
                widget.subTitle,
                style: TextStyle(
                    color: widget.textColor, fontSize: 18, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
