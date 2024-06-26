import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shareride/screens/register_page.dart';
import 'package:shareride/utilities/app_colors.dart';
import 'package:shareride/utilities/app_text_styles.dart';
import 'package:shareride/utilities/button1.dart';
import 'package:shareride/utilities/form_decoration.dart';

import '../providers/user_provider.dart';
import '../utilities/app_snackbar.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signinFormKey = GlobalKey<FormState>();
  ButtonState _buttonState = ButtonState.normal;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                              'Welcome Back!',
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
                      Expanded(child: SingleChildScrollView(
                        child: Container(
                          decoration: AppFormDecoration.boxDecoration,
                          margin: AppFormDecoration.margin,
                          padding: AppFormDecoration.padding,
                          width: double.maxFinite,
                          child: Form(
                            key: _signinFormKey,
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
                                      style: AppTextStyle.formLabel           
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
                                      keyboardType: TextInputType.visiblePassword,
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
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context, MaterialPageRoute(
                                        builder: (context)=> const RegisterPage()
                                      )
                                    );
                                  },
                                  child: Text(
                                    'Register New Account',
                                    style: AppTextStyle.authnb,  
                                  ),
                                ),
                                const SizedBox(
                                  height: 42,
                                ),
                                GestureDetector(
                                  onTap: () async{
                                    if (_signinFormKey.currentState!.validate() && _buttonState != ButtonState.loading) {
                                      setState(() {
                                        _buttonState = ButtonState.loading; 
                                      });
                                      await context.read<UserProvider>().signinUser(
                                        email: _emailController.text,
                                        password: _passwordController.text
                                      ).then(
                                        (value) async{
                                          setState(() {
                                            _buttonState = ButtonState.normal; 
                                          });
                                          // await Future.delayed(
                                          //   const Duration(milliseconds: 400)
                                          // ).then(
                                          //   (value) {
                                          //     setState(() {
                                          //       _buttonState = ButtonState.normal;
                                          //     });
                                          //   }
                                          // );
                                        }
                                      ).catchError((e) async{
                                        setState(() {
                                          _buttonState = ButtonState.error; 
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.error((e as FirebaseAuthException).code));
                                        await Future.delayed(
                                          const Duration(seconds: 1)
                                        ).then(
                                          (value) {
                                            setState(() {
                                              _buttonState = ButtonState.normal;
                                            });
                                          }
                                        );                               
                                        
                                      });
                                    }
                                  },
                                  child: AppButton(
                                    label: 'Login',
                                    state: _buttonState,
                                    height: 40.h, 
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ))
                      

                    ],
                  ),
                ),
              )
            )  
          ],
        ),
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
