import 'package:shop_app/models/shop_app/login_model.dart';
import 'package:shop_app/models/shop_app/product%20_details_model.dart';

abstract class ShopStates{}

class ShopInitialState extends ShopStates{}

class ShopChangeBottomNavState extends ShopStates{}

class ShopLoadingHomeDataState extends ShopStates{}

class ShopSuccessHomeDataState extends ShopStates{}

class ShopErrorHomeDataState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates{}

class ShopLoadingCategoriesState extends ShopStates{}

class ShopErrorCategoriesState extends ShopStates {}

class ShopSuccessChangeFavoritesState extends ShopStates{}

class ShopChangeFavoritesState extends ShopStates{}

class ShopErrorChangeFavoritesState extends ShopStates {}


class ShopSuccessGetFavoritesState extends ShopStates{}

class ShopErrorGetFavoritesState extends ShopStates {}

class ShopLoadingGetFavoritesState extends ShopStates {}


class ShopSuccessUserDataState extends ShopStates
{
  final ShopLoginModel? loginModel;

  ShopSuccessUserDataState(this.loginModel);
}

class ShopErrorUserDataState extends ShopStates {}

class ShopLoadingUserDataState extends ShopStates {}



class ShopSuccessUpdateUserState extends ShopStates
{
  final ShopLoginModel? loginModel;

  ShopSuccessUpdateUserState(this.loginModel);
}

class ShopErrorUpdateUserState extends ShopStates {}

class ShopLoadingUpdateUserState extends ShopStates {}





class ShopSuccessProductDetailsState extends ShopStates
{
  final ProductDetails? productDetails;

  ShopSuccessProductDetailsState(this.productDetails);
}

class ShopErrorProductDetailsState extends ShopStates {}

class ShopLoadingProductDetailsState extends ShopStates {}