import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shareride/providers/user_provider.dart';
import 'package:shareride/providers/whatsapp_provider.dart';
import 'package:shareride/utilities/app_colors.dart';
// import 'package:shareride/utilities/app_snackbar.dart';
import '../utilities/button1.dart';
import '../utilities/form_decoration.dart';

class DepositPage extends StatefulWidget {
  const DepositPage({super.key});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final _amountController = TextEditingController();
  final _emailController = TextEditingController();
  final plugin = PaystackPlugin();
  final _formKey = GlobalKey<FormState>();
  
  final buttonState = ButtonState.normal;

  @override
  void initState() {
    plugin.initialize(publicKey: context.read<WhatsappProvider>().key);
    super.initState();
  }
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
                              'Deposit With PayStack',
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
                          // height: 413,
                          width: double.maxFinite,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                profileCard,
                                const SizedBox(height: 12,),
                                AppFormDecoration.formField(
                                  _amountController, 
                                  'Amount', 
                                  '2000', 
                                  (p0) {
                                    if (p0 == null || p0.isEmpty || int.tryParse(p0) == null) {
                                      return 'Invalid field';
                                    } else {
                                      return null;
                                    }
                                  },
                                  TextInputType.number
                                ),                        
                                AppFormDecoration.formField(
                                  _emailController, 
                                  'Email', 
                                  'janedoe@who.com', 
                                  (p0) {
                                    if (p0 == null || p0.isEmpty || p0.length < 8) {
                                      return 'Invalid field';
                                    } else {
                                      return null;
                                    }
                                  },
                                  TextInputType.emailAddress
                                ),
                                const SizedBox(height: 8,),
                                GestureDetector(
                                  onTap: () async{
                                    if (_formKey.currentState!.validate()) {  
                                      final ref_ = 'ref_${DateTime.now().millisecondsSinceEpoch}';
                                      Charge charge = Charge()
                                            ..currency = "NGN"
                                            ..amount = int.parse(_amountController.text)*100
                                            ..email = _emailController.text
                                            ..reference = ref_;
                                          await plugin.checkout(context, charge: charge, method: CheckoutMethod.card).then((value) async {
                                            if (value.status) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Payment Successful!: ${value.reference}'))
                                              );
                                              await context.read<UserProvider>().loadBalance(int.parse(_amountController.text));
                                              _amountController.clear();
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Payment failed'))
                                              );
                                            }
                                          });
                                      // await context.read<WhatsappProvider>().createAccessCode(_emailController.text, int.parse(_amountController.text), ref_).then(
                                      //   (value) async{
                                          
                                      //   }
                                      // ).catchError((e){
                                      //   ScaffoldMessenger.of(context).showSnackBar(
                                      //     AppSnackBar.normal(e)
                                      //   );
                                      // });                            
                                      
                                      
                                    } 
                                  },
                                  child: AppButton(
                                    label: 'Proceed To PayStack', 
                                    state: buttonState,
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
        )
      ),
    );
  }

      
  Widget get _appbar => SizedBox(
    height: 80.h,
    width: double.maxFinite,
    child: Row(
      children: [
        IconButton(
          onPressed: ()=> Navigator.pop(context), 
          icon: Icon(
            Icons.arrow_back,
            size:  24.sp,
            color: Colors.black,
          )
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Image.asset('assets/shareridelogo.png'),
        )
      ],
    ),
  );

Widget get profileCard=> Container(
    padding: EdgeInsets.symmetric(horizontal :10.w, vertical: 10.h),
    width: double.maxFinite,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      gradient:const LinearGradient(
        colors: [
          Color.fromRGBO(12, 33, 74, 1),
          Color.fromRGBO(29, 78, 176, 1)
        ]
      )
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Available Balance',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white
          ),          
        ),
        _spacing(14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'N${context.watch<UserProvider>().user.balance.toString()}.00',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),
            ),
          ],
        )
      ],
    ),
  );

  Widget _spacing(double height)=> SizedBox(height: height,);
}