import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import 'package:shop_app/models/shop_app/categories.dart';
import 'package:shop_app/models/shop_app/change_favorites_model.dart';
import 'package:shop_app/models/shop_app/favorites_model.dart';
import 'package:shop_app/models/shop_app/home_model.dart';
import 'package:shop_app/models/shop_app/login_model.dart';
import 'package:shop_app/models/shop_app/product%20_details_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorite/favorite_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/components/constant.dart';
import 'package:shop_app/shared/network/end_point/end_point.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates>
{
  ShopCubit() : super(ShopInitialState());
  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> bottomScreens =
  [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoriteScreen(),
     SettingsScreen(),
  ];


  void changeBottom(int index)
  {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int?,bool? >? favorites = {};
  void getHomeData()
  {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
        url: home,
        token:token,
    ).then((value)
    {
      homeModel=HomeModel.fromJson(value.data);
      // print(homeModel?.data?.banners[0].image);
      // print(homeModel?.status);
      homeModel!.data!.products.forEach((element) {
        favorites?.addAll({
          element.id : element.inFavorites,
        });
      });
      print(favorites.toString());
      emit(ShopSuccessHomeDataState());
    }).catchError((onError)
    {
      print(onError.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;
  void getCategories()
  {
    emit(ShopLoadingCategoriesState());
    DioHelper.getData(
      url: GET_CATEGORIES,
      token:token,
    )?.then((value)
    {
      categoriesModel=CategoriesModel.fromJson(value.data);
      print(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((onError)
    {
      print(onError.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId)
  {
    favorites![productId] = !favorites![productId]!;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
        url: FAVORITES,
        data: {
          'product_id' : productId,
        },
      token:token ,
    )?.then((value)
    {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);

      if(!changeFavoritesModel?.status)
      {
        favorites![productId] = !favorites![productId]!;
      }else{
        getFavorites();
      }

      emit(ShopSuccessChangeFavoritesState());
    }).catchError((error)
    {
      favorites![productId] = !favorites![productId]!;
      emit(ShopErrorChangeFavoritesState());

    });
  }

  FavoritesModel? favoritesModel;
  void getFavorites()
  {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token:token,
    )?.then((value)
    {
      favoritesModel=FavoritesModel.fromJson(value.data);
      print(value.data.toString());
      emit(ShopSuccessGetFavoritesState());
    }).catchError((onError)
    {
      print(onError.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;
  void getUserData()
  {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url: profile,
      token:token,
    )?.then((value)
    {
      userModel=ShopLoginModel.fromJson(value.data);
      print(userModel!.data!.name);
      emit(ShopSuccessUserDataState(userModel));
    }).catchError((onError)
    {
      print(onError.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
  required String? name,
  required String? email,
  required String? phone,
})
  {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
      url: updateProfile,
      token:token,
      data:{
        'name' : name,
        'email' : email,
        'phone' : phone,
      } ,
    )?.then((value)
    {
      userModel=ShopLoginModel.fromJson(value.data);
      print(userModel!.data!.name);
      emit(ShopSuccessUpdateUserState(userModel));
    }).catchError((onError)
    {
      print(onError.toString());
      emit(ShopErrorUpdateUserState());
    });
  }

  // ProductDetails? productDetails;
  // void getProductDetails()
  // {
  //   emit(ShopLoadingProductDetailsState());
  //   DioHelper.getData(
  //     url:productDetailsEndPoint,
  //     token:token,
  //   )?.then((value)
  //   {
  //     productDetails=ProductDetails.fromJson(value.data);
  //     print(value.data.toString());
  //     emit(ShopSuccessProductDetailsState(productDetails));
  //   }).catchError((onError)
  //   {
  //     print(onError.toString());
  //     emit(ShopErrorProductDetailsState());
  //   });
  // }
}
