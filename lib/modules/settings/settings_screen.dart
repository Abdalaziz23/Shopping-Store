import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import 'package:shop_app/shared/components/component.dart';
import 'package:shop_app/shared/components/constant.dart';

class SettingsScreen extends StatelessWidget {
  //const SettingsScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state) {},
      builder: (context,state)
      {
        var model = ShopCubit.get(context).userModel;
        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;
        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          fallback: (context) => const Center(child: CircularProgressIndicator()),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children:
                [
                  if(state is ShopLoadingUpdateUserState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 16,
                  ),
                  defaultFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    validator: (value)
                    {
                      if(value.isEmpty)
                      {
                        return 'Name must not be empty';
                      }
                      return null;
                    },
                    labelText: 'Name',
                    prefix: Icons.person,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  defaultFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value)
                    {
                      if(value.isEmpty)
                      {
                        return 'email must not be empty';
                      }
                      return null;
                    },
                    labelText: 'Email Address',
                    prefix: Icons.email,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  defaultFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value)
                    {
                      if(value.isEmpty)
                      {
                        return 'phone must not be empty';
                      }
                      return null;
                    },
                    labelText: 'Phone ',
                    prefix: Icons.phone_android,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  defaultButton(
                    function: ()
                    {
                      if(formKey.currentState!.validate())
                        {
                          ShopCubit.get(context).updateUserData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          );
                        }
                    },
                    text: 'update',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  defaultButton(
                      function: ()
                      {
                        signOut(context);
                      },
                      text: 'logout',
                  ),
                ],
              ),
            ),
          ) ,
        );
      },
    );
  }
}