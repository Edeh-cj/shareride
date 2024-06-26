import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shareride/providers/user_provider.dart';
import 'package:shareride/utilities/app_text_styles.dart';
import 'package:shareride/utilities/button1.dart';
import 'package:shareride/utilities/form_decoration.dart';

import '../utilities/app_colors.dart';
import '../utilities/app_snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  ButtonState _buttonState = ButtonState.normal;
  final _registerFormKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _appbar,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, -4.h),
                    blurRadius: 4.h
                  )
                ]
              ),
              child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.0.w, top: 24.h, bottom: 24.h),
                          child: Text(
                            'Welcome To Shareride',
                            style: TextStyle(
                              color: const Color.fromRGBO(27, 27, 31, 1),
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h,),
                    Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: AppFormDecoration.boxDecoration,
                        margin: AppFormDecoration.margin,
                        padding: AppFormDecoration.padding,
                        width: double.maxFinite,
                        child: Form(
                          key: _registerFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppFormDecoration.formField(
                                _emailController, 
                                'Email', 
                                null, 
                                (p0) {
                                  if (p0 == null || p0.isEmpty || p0.length < 8) {
                                    return 'Invalid field';
                                  } else {
                                    return null;
                                  }
                                },
                                TextInputType.emailAddress
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Password',
                                    style: AppTextStyle.formLabel,            
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    validator: (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'Invalid field';
                                      } else {
                                        return null;
                                      }
                                    },
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: (){
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        }, icon: Icon(_obscureText ? Icons.visibility_off_outlined: Icons.visibility_outlined)),
                                      constraints: BoxConstraints.tight(
                                        const Size(double.maxFinite, 36)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        borderSide: const BorderSide(
                                          color: Color.fromRGBO(217, 217, 217, 1)
                                        )
                                      ),
                                      hintStyle: const TextStyle(
                                        fontSize: 13,
                                      )
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                              AppFormDecoration.formField(
                                _nameController, 
                                'First/Nick Name', 
                                null, 
                                (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Invalid field';
                                  } else {
                                    return null;
                                  }
                                },
                                TextInputType.name
                              ),
                              AppFormDecoration.formField(
                                _phoneController, 
                                'Phone Number', 
                                null, 
                                (p0) {
                                  if (p0 == null || p0.isEmpty || int.tryParse(p0) == null) {
                                    return 'Invalid field';
                                  } else {
                                    return null;
                                  }
                                },
                                TextInputType.phone
                              ),  
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Text(
                                    'Already have an Account? Login',
                                    style: AppTextStyle.authnb,  
                                  ),
                              ) ,
                              const SizedBox(
                                height: 42,
                              ),
                              GestureDetector(
                                onTap: (){
                                  if (_registerFormKey.currentState!.validate()&& _buttonState != ButtonState.loading && int.tryParse(_phoneController.text) != null) {
                                    setState(() {
                                      _buttonState = ButtonState.loading; 
                                    });
                                    context.read<UserProvider>().registerUser(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      phonenumber: int.parse(_phoneController.text),
                                      password: _passwordController.text
                                    ).then(
                                      (value) {
                                        // setState(() {
                                        //   _buttonState = ButtonState.normal; 
                                        // });
                                        Navigator.pop(context);
                                      }
                                      
                                    ).catchError((e){
                                      setState(() {
                                        _buttonState = ButtonState.error; 
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.error((e as FirebaseAuthException).code));
                                      // Future.delayed(
                                      //   const Duration(seconds: 1)
                                      // ).then(
                                      //   (value) {
                                      //     setState(() {
                                      //       _buttonState = ButtonState.normal;
                                      //     });
                                      //   }
                                      //   );
                                    });
                                  }
                                },
                                child: AppButton(
                                  label: 'Register', 
                                  state: _buttonState,
                                  height: 40.h,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )

                  ],
                ),
              ),
            )
          )  ,


        ],
      ),
    );
  }


  Widget get _appbar => SizedBox(
    height: 80.h,
    width: double.maxFinite,
    child: Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/shareridelogo.png')),
    ),
  );
  
}