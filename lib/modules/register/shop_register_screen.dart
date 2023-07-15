import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/shop_layout.dart';
import 'package:shop_app/modules/register/cubit/cubit.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/modules/shop_login/cubit/cubit.dart';
import 'package:shop_app/shared/components/component.dart';
import 'package:shop_app/shared/components/constant.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class ShopRegisterScreen extends StatelessWidget {
  //const RegisterScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit,ShopRegisterStates>(
        listener: (context,state)
        {
          if(state is ShopRegisterSuccessStates){
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
            }else{
              print(state.loginModel.message);
            }
          }
        },
        builder: (context,state)
        {
          return Scaffold(
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
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Register now to browse our hot offers',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          defaultFormField(
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            validator: (value)
                            {
                              if(value.isEmpty)
                              {
                                return 'Enter Your Name';
                              }
                              return null;
                            },
                            labelText: 'Name ',
                            prefix: Icons.person,
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
                            suffix: ShopRegisterCubit.get(context).suffix,
                            keyboardType: TextInputType.visiblePassword,
                            onPressed: ()
                            {
                              ShopRegisterCubit.get(context).changePasswordVisibility();
                            },
                            obscureText:ShopRegisterCubit.get(context).isPassword,
                            onFieldSubmit: (value)
                            {

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
                            height: 20.0,
                          ),
                          defaultFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value)
                            {
                              if(value.isEmpty)
                              {
                                return 'Enter Your Phone';
                              }
                              return null;
                            },
                            labelText: 'phone',
                            prefix: Icons.email,
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          ConditionalBuilder(
                            fallback: (context)=>const Center(child: CircularProgressIndicator()),
                            condition: state is! ShopRegisterLoadingStates,
                            builder: (context)=> defaultButton(
                              function: ()
                              {
                                if(formKey.currentState!.validate())
                                {
                                  ShopRegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text
                                  );
                                }
                              },
                              text: 'register',
                            ),
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
