import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app/models/shop_app/favorites_model.dart';
import 'package:shop_app/models/shop_app/search_model.dart';
import 'package:shop_app/modules/search/cubit/cubit.dart';
import 'package:shop_app/modules/search/cubit/states.dart';
import 'package:shop_app/modules/web_view_screen/web_view_screen.dart';
import 'package:shop_app/shared/components/component.dart';
import 'package:shop_app/shared/components/constant.dart';
import 'package:shop_app/shared/network/end_point/end_point.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit,SearchStates>(
        listener: (context,state){},
        builder:(context,state)
        {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    defaultFormField(
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        validator: (value)
                        {
                          if(value.isEmpty)
                          {
                            return 'Enter Your Phone';
                          }
                          return null;
                        },
                        labelText: 'Search',
                        prefix: Icons.search,
                        onFieldSubmit: (String? text)
                        {
                          if(formKey.currentState!.validate())
                          {
                            SearchCubit.get(context).search(text);

                          }
                        },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if(state is SearchLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(
                      height: 10,
                    ),
                    if(state is SearchSuccessState)
                        Expanded(
                           child: ListView.separated(
                             physics:const BouncingScrollPhysics(),
                             itemBuilder: (BuildContext context, int index) =>buildFavItem(SearchCubit.get(context).model!.data!.data[index],context,isOldPrice: false,),
                             separatorBuilder:  (context,index) =>myDivider(),
                             itemCount: SearchCubit.get(context).model!.data!.data.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ) ;
        },
      ),
    );
  }
  Widget buildFavItem(Product? model,context,{bool isOldPrice = true }) => Padding(
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
                      '${model!.image}',
                    ),
                    width: 120,
                    height: 120.0,
                  ),
                ),
                if(model.discount != 0 && isOldPrice)
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
                    '${model!.name}',
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
                        '${model!.price.toString()}',
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
                      if(model.discount != 0 && isOldPrice)
                        Text(
                          '${model!.oldPrice.toString()}',
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
                          //  print(model.id);
                        },
                        icon: CircleAvatar(
                         //backgroundColor: ShopCubit.get(context)!.favorites![model.id]! ? defaultColor : Colors.grey,
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

  Widget buildSearchItem(model,context,) =>Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      color:  Colors.white,
      height: 120,
      child: Row(
        children: [
          Image(
            image: NetworkImage(
              '${model!.image}',
            ),
            height: 120,
            width: 120,
          ),
          const SizedBox(width: 16,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model!.name}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.3,
                  ),
                ),
                // const SizedBox(
                //   height: 20.0,
                // ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      '${model!.price.toString()}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.0,
                        height: 1.3,
                        color: defaultColor,
                      ),
                    ),
                    IconButton(
                      onPressed: ()
                      {
                        //ShopCubit.get(context).changeFavorites(model.id);
                        //  print(model.id);
                      },
                      icon: CircleAvatar(
                        backgroundColor: ShopCubit.get(context).favorites![model.id]! ? defaultColor : Colors.grey,
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
              ],
            ),
          ),
        ],
      ),
    ),
  );
}