import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import 'package:shop_app/models/shop_app/categories.dart';
import 'package:shop_app/models/shop_app/home_model.dart';
import 'package:shop_app/shared/components/constant.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        return ConditionalBuilder(
          condition:  ShopCubit.get(context).homeModel != null && ShopCubit.get(context).categoriesModel != null,
          builder: (context) => productsBuilder(ShopCubit.get(context).homeModel,ShopCubit.get(context).categoriesModel,context),
          fallback: (context) =>const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(HomeModel? model,CategoriesModel? categoriesModel,context) =>SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
        CarouselSlider(
            items:model?.data?.banners.map((e) => Image(
              image: NetworkImage('${e.image}'),
              width: double.infinity,
              fit: BoxFit.cover,

            ),).toList(),
            options: CarouselOptions(
              height: 250.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval:  const Duration(seconds: 3,),
              autoPlayAnimationDuration: const Duration(seconds: 1,),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1.0,
            ),
        ),
        const SizedBox(
          height: 1.05,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
          ),
          child: Container(
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 5,
                    top: 10,
                  ),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding:const EdgeInsets.symmetric(
                    vertical: 5,
                  ) ,
                  color: Colors.grey[200],
                  height: 110.0,
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                      itemBuilder: ( context,  index) =>buildCategoriesItem(categoriesModel.data!.data[index]),
                      separatorBuilder: ( context,  index) =>const SizedBox(
                        width: 5,
                      ),
                      itemCount: categoriesModel!.data!.data.length,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 5,
                    bottom: 5,
                  ),
                  child: Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 1.05,
        ),
        Container(
          color: Colors.grey[300],
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            childAspectRatio: 1/1.3,
            children: List.generate(
                  model!.data!.products.length,
                  (index) => buildGridProduct(model.data!.products[index],context),
            ),
          ),
        ),
      ],
    ),
  );
   Widget buildCategoriesItem(DataModel? model) => Stack(
     alignment: AlignmentDirectional.bottomCenter,
     children:
     [
       Image(
         image: NetworkImage(
           '${model!.image}',
         ),
         height: 100.0,
         width:100.0,
         fit: BoxFit.cover,
       ),
       Container(
         width: 100.0,
         color: Colors.black.withOpacity(.8,),
         child: Text(
           '${model.name}',
           textAlign: TextAlign.center,
           maxLines: 1,
           overflow: TextOverflow.ellipsis,
           style: TextStyle(
             color:Colors.white ,
           ),
         ),
       ),
     ],
   );
   Widget buildGridProduct(ProductsModel model,context) =>Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Container(
              color: Colors.white,
              height: 200.0,
              width: double.infinity,
              child: Image(
                image: NetworkImage(
                  '${model.image}',
                ),
                width: double.infinity,
                height: 200.0,
              ),
            ),
            if(model.discount != 0)
              Container(
              margin:const EdgeInsetsDirectional.only(
                start:5.0 ,
              ),
              color: Colors.red,
              padding: EdgeInsets.symmetric(
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
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                height:36.0,
                child: Text(
                  '${model.name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.3,
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                height: 45.0,
                child: Row(
                  children: [
                    Text(
                      '${model.price.round()}',
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
                    if(model.discount != 0)
                      Text(
                      '${model.oldPrice.round()}',
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
                          ShopCubit.get(context).changeFavorites(model.id);
                          print(model.id);
                        },
                        icon: CircleAvatar(
                          backgroundColor: ShopCubit.get(context).favorites![model.id]! ? defaultColor : Colors.grey,
                          radius: 17.0,
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
  );
}
