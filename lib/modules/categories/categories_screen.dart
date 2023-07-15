import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import 'package:shop_app/models/shop_app/categories.dart';
import 'package:shop_app/shared/components/component.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){} ,
      builder:(context,state)
      {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).categoriesModel != null,
          fallback:(BuildContext context) =>Center(child: CircularProgressIndicator()) ,
          builder:(BuildContext context)
          {
            return  ListView.separated(
              itemBuilder: (BuildContext context, int index) => buildCatItem(ShopCubit.get(context).categoriesModel!.data!.data[index]) ,
              separatorBuilder:  (context,index) =>myDivider(),
              itemCount: ShopCubit.get(context).categoriesModel!.data!.data.length,
            ) ;
          } ,
        );
      } ,
    );
  }
  Widget buildCatItem(DataModel? model) =>  Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        Image(
          image: NetworkImage(
            '${model!.image}',
          ),
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          '${model.name}',
          style: TextStyle(
              fontSize:20 ,
              fontWeight: FontWeight.bold
          ),
        ),
        Spacer(),
        Icon(
          Icons.arrow_forward_ios,
        ),
      ],
    ),
  );
}