import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import 'package:shop_app/modules/search/search_screen.dart';
import 'package:shop_app/modules/shop_login/shop_login_screen.dart';
import 'package:shop_app/shared/components/component.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,states){},
      builder: (context,states)
      {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Shopping Store',
            ),
            actions: [
              IconButton(
                  onPressed: ()
                  {
                    navigateTo(context, const SearchScreen());
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
              ),
            ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeBottom(index);
            },
            items:
            const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                label:'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.apps,
                  ),
                label:'Categories',
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                  ),
                label:'Favorite',
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                  ),
                label:'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
