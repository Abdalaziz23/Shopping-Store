import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import 'package:shop_app/models/shop_app/favorites_model.dart';
import 'package:shop_app/shared/components/component.dart';

import '../../shared/components/constant.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return  BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){} ,
      builder:(context,state)
      {
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavoritesState && ShopCubit.get(context).favoritesModel != null,
          builder: (context) => ListView.separated(
            itemBuilder: (BuildContext context, int index) =>buildFavItem(ShopCubit.get(context).favoritesModel!.data!.data[index],context),
            separatorBuilder:  (context,index) =>myDivider(),
            itemCount: ShopCubit.get(context).favoritesModel!.data!.data.length,
          ) ,
          fallback: (context) => const Center(child: CircularProgressIndicator()) ,
        );
      } ,
    );
  }
  Widget buildFavItem(FavoritesData? model,context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      color: Colors.white,
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            height: 120,
            width: 120,
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  color: Colors.white,
                  height: 200.0,
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(
                      '${model!.product!.image}',
                    ),
                    width: 120,
                    height: 120.0,
                  ),
                ),
                if(model.product!.discount != 0)
                  Container(
                    color: Colors.red,
                    padding:const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: Text(
                      'DISCOUNT',
                      style: TextStyle(
                        fontSize: 8.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    '${model!.product!.name}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  color: Colors.white,
                  height: 45.0,
                  child: Row(
                    children: [
                      Text(
                        '${model!.product!.price.toString()}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                          height: 1.3,
                          color: defaultColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if(model.product!.discount != 0)
                        Text(
                          '${model!.product!.oldPrice.toString()}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: ()
                        {
                          ShopCubit.get(context).changeFavorites(model.product?.id);
                          //  print(model.id);
                        },
                        icon: CircleAvatar(
                          backgroundColor: ShopCubit.get(context).favorites![model.product?.id]! ? defaultColor : Colors.grey,
                          radius: 17.0,
                          // ShopCubit.get(context).favorites![model.id]!
                          child: Icon(
                            Icons.favorite_outline,
                            size: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}