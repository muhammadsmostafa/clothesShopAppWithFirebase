import 'package:clothes_shop_app/modules/login/login_screen.dart';
import 'package:clothes_shop_app/modules/register/register_screen.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: defaultColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
                'assets/images/test_logo.png'
            ),
          ),
          defaultButton(
              function: ()
              {
                navigateTo(
                  context,
                  const RegisterScreen(),
                );
              },
              text: 'GET STARTED',
              background: Colors.white,
              textColor: defaultColor,
          ),
          const SizedBox(
            height: 20,
          ),
          defaultTextButton(
              function: ()
              {
                navigateTo(
                  context,
                  const LoginScreen(),
                );
              },
              text: 'SIGN IN',
              textColor: Colors.white
          ),
          const SizedBox(
            height: 150,
          )
        ],
      ),
    );
  }
}
