import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/shop_layout.dart';
import 'package:shop_app/shared/components/constant.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:toast/toast.dart';
import 'package:shop_app/modules/register/shop_register_screen.dart';
import 'package:shop_app/modules/shop_login/cubit/cubit.dart';
import 'package:shop_app/modules/shop_login/cubit/states.dart';
import 'package:shop_app/shared/components/component.dart';

class ShopLoginScreen extends StatelessWidget {
  //const ShopLoginScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    //ToastContext().init(context);
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
         listener: (context,state)
         {
           ToastContext().init(context);
           if(state is ShopLoginSuccessStates){
             if(state.loginModel.status!){
               print(state.loginModel.message);
               print(state.loginModel.data?.token);
               CacheHelper.savedData(
                   key: 'token',
                   value: state.loginModel.data?.token,
               ).then((value) {
                 token = state.loginModel.data?.token;
                 navigateAndFinish(context, ShopLayout());
               });
               // Toast.show(
               //   '${state.loginModel.message}',
               //   duration: Toast.lengthLong,
               //   backgroundColor: Colors.green,
               //   textStyle: TextStyle(
               //     color: Colors.white,
               //     fontSize: 16.0,
               //   ),
               //   gravity:  	Toast.top ,
               // );
             }else{
               print(state.loginModel.message);
               // Toast.show(
               //   '${state.loginModel.message}',
               //     duration: Toast.lengthLong,
               //     backgroundColor: Colors.red,
               //     textStyle: TextStyle(
               //       color: Colors.white,
               //       fontSize: 16.0,
               //     ),
               //     gravity:  Toast.center,
               // );
             }
           }
         },
         builder: (context,state)
         {
           ShopLoginCubit cubit = ShopLoginCubit.get(context);
           return  Scaffold(
             appBar: AppBar(),
             body: Center(
               child: SingleChildScrollView(
                 child: Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Form(
                     key: formKey,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           'LOGIN',
                           style: TextStyle(
                             fontSize: 25.0,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         const SizedBox(
                           height: 10.0,
                         ),
                         Text(
                           'login now to browse our hot offers',
                           style: TextStyle(
                             fontSize: 16.0,
                             color: Colors.grey,
                           ),
                         ),
                         const SizedBox(
                           height: 20.0,
                         ),
                         defaultFormField(
                           controller: emailController,
                           keyboardType: TextInputType.emailAddress,
                           validator: (value)
                           {
                             if(value.isEmpty)
                             {
                               return 'Enter Your Email';
                             }
                             return null;
                           },
                           labelText: 'Email Address',
                           prefix: Icons.email,
                         ),
                         const SizedBox(
                           height: 15.0,
                         ),
                         defaultFormField(
                           controller: passwordController,
                           suffix: cubit.suffix,
                           keyboardType: TextInputType.visiblePassword,
                           onPressed: ()
                           {
                            cubit.changePasswordVisibility();
                           },
                           obscureText:cubit.isPassword,
                           onFieldSubmit: (value){
                             if(formKey.currentState!.validate())
                             {
                               ShopLoginCubit.get(context).userLogin(
                                 email: emailController.text,
                                 password: passwordController.text,
                               );
                             }
                           },
                           validator: (value)
                           {
                             if(value.isEmpty)
                             {
                               return 'Password is too short';
                             }
                             return null;
                           },
                           labelText: 'Password',
                           prefix: Icons.lock_outline,
                         ),
                         const SizedBox(
                           height: 30.0,
                         ),
                         ConditionalBuilder(
                           fallback: (context)=>Center(child: CircularProgressIndicator()),
                           condition: state is! ShopLoginLoadingStates,
                           builder: (context)=> defaultButton(
                             function: ()
                             {
                               if(formKey.currentState!.validate())
                               {
                                 ShopLoginCubit.get(context).userLogin(
                                   email: emailController.text,
                                   password: passwordController.text,
                                 );
                               }
                             },
                             text: 'LOGIN',
                           ),
                         ),
                         const SizedBox(
                           height: 15.0,
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children:
                           [
                             Text(
                               'Don\'t have an account?',
                             ),
                             defaultTextButton(
                               onPressed: ()
                               {
                                 navigateTo(context, ShopRegisterScreen());
                               },
                               text: 'Register',
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
             ),
           );
         },
      ),
    );
  }
}
