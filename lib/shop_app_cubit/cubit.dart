import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shop_app_cubit/states.dart';

class ShopAppCubit extends Cubit<ShopAppStates>
{
  ShopAppCubit() : super(ShopAppInitialState());
  static ShopAppCubit get(context) => BlocProvider.of(context);
}