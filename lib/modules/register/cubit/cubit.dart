import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app/login_model.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/modules/shop_login/cubit/states.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../../shared/network/end_point/end_point.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>
{
  ShopRegisterCubit() : super(ShopRegisterInitialStates());
  static ShopRegisterCubit get(context) => BlocProvider.of(context);
  ShopLoginModel? loginModel;

  void userRegister({
  required String email,
  required String password,
  required String name,
  required String phone,
})
  {
    emit(ShopRegisterLoadingStates());

    DioHelper.postData(
        url: REGISTER,
        data: {
          'name': name,
          'email': email,
          'password':password,
          'phone':phone,
        },
    )?.then((value)
    {
      print(value.data);
      loginModel= ShopLoginModel.fromJson(value.data);
      print(loginModel?.status);
      print(loginModel?.message);
      print(loginModel?.data?.token);
      emit(ShopRegisterSuccessStates(loginModel!));
    }).catchError((onError){
      emit(ShopRegisterErrorStates(onError));
    });
  }

  IconData? suffix = Icons.visibility_off_outlined;
  bool isPassword = true;
  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(ShopRegisterChangePasswordVisibilityStates());
  }
}