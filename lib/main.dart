import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app/layout/shop_app/shop_layout.dart';
import 'package:shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/modules/shop_login/shop_login_screen.dart';
import 'package:shop_app/shared/block_observer.dart';
import 'package:shop_app/shared/components/constant.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'package:shop_app/shop_app_cubit/cubit.dart';
import 'package:shop_app/shop_app_cubit/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  print(onBoarding);

  Widget widget ;
  token = CacheHelper.getData(key: 'token');
  print('token $token');

  if(onBoarding != null){
    if(token != null)
    {
      widget = const ShopLayout();
    }
    else
    {
      widget = ShopLoginScreen();
    }
  }else{
    widget = OnBoardingScreen();
  }

  runApp(  MyApp(widget));
}

class MyApp extends StatelessWidget {
  //const MyApp({super.key});
  final Widget  startWidget;
  MyApp(this.startWidget);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:
      [
        BlocProvider(
          create:(BuildContext context) =>ShopAppCubit(),
        ),
        BlocProvider(
            create:(BuildContext context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),
        ),
      ],
      child: BlocConsumer<ShopAppCubit,ShopAppStates>(
        listener: (context,states){},
        builder: (context,states)
        {
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            home:startWidget,
          ) ;
        },
      ),
    );
  }
}
