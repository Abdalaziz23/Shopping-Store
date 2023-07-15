import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app/login_model.dart';
import 'package:shop_app/modules/shop_login/cubit/states.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../../shared/network/end_point/end_point.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>
{
  ShopLoginCubit() : super(ShopLoginInitialStates());
  static ShopLoginCubit get(context) => BlocProvider.of(context);
  ShopLoginModel? loginModel;

  void userLogin({
  required String email,
  required String password,
})
  {
    emit(ShopLoginLoadingStates());

    DioHelper.postData(
        url: LOGIN,
        data: {
          'email': email,
          'password':password,
        },
    )?.then((value)
    {
      print(value.data);
      loginModel= ShopLoginModel.fromJson(value.data);
      print(loginModel?.status);
      print(loginModel?.message);
      print(loginModel?.data?.token);
      emit(ShopLoginSuccessStates(loginModel!));
    }).catchError((onError){
      emit(ShopLoginErrorStates(onError));
    });
  }

  IconData? suffix = Icons.visibility_off_outlined;
  bool isPassword = true;
  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(ShopChangePasswordVisibilityStates());
  }
}