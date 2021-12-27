import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:clothes_shop_app/layout/app_layout.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 200,
      duration: 1000,
      backgroundColor: defaultColor,
      splash: Column(
        mainAxisSize: MainAxisSize.max,
        children:
        const [
          CircleAvatar(
            child: Center(
              child: Text(
                'C',
                style: TextStyle(
                    fontSize: 33,
                    color: defaultColor,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            radius: 30,
            backgroundColor: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
              'Clothes Market',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              )
          ),
        ],
      ),
      nextScreen: const AppLayout(),
      splashTransition: SplashTransition.scaleTransition,
    );
  }
}
