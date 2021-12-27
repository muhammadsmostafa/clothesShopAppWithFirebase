import 'package:bloc/bloc.dart';
import 'package:clothes_shop_app/modules/onboarding_and_splash/onboarding_screen.dart';
import 'package:clothes_shop_app/shared/bloc_observer.dart';
import 'package:clothes_shop_app/shared/components/constants.dart';
import 'package:clothes_shop_app/shared/network/local/cashe_helper.dart';
import 'package:clothes_shop_app/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';
import 'modules/onboarding_and_splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //to be sure that every thing on the method done and then open the app

  await Firebase.initializeApp();
  await CasheHelper.init();

  Bloc.observer = MyBlocObserver();
  Widget widget;

  uId = CasheHelper.getData(key: 'uId') ?? '';

  if(uId == '')
  {
    widget = const OnboardingScreen();
  }
  else
  {
    widget = const SplashScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}
bool firstTime = true;

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({Key? key, required this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state)
        {
          if(state is AppGetFavoriteSuccessState)
            {
              AppCubit.get(context).getFavoriteScreen();
            }
          if(state is AppGetCartSuccessState)
            {
              AppCubit.get(context).getCartProductModel();
            }
          if(state is AppGetCartProductModelSuccessState)
            {
              AppCubit.get(context).getCartScreen();
            }
          if(state is AppGetCartScreenSuccessState)
            {
              AppCubit.get(context).getTotalPrice();
            }
        },
        builder: (context, state) {
          if(uId != '' && firstTime)
            {
              firstTime = false;
              AppCubit.get(context).getUserData();
              AppCubit.get(context).getProducts();
              AppCubit.get(context).getFavorites();
              AppCubit.get(context).getCart();
            }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            themeMode: ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}