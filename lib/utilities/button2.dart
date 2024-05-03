import 'package:flutter/material.dart';
import 'package:shareride/utilities/app_colors.dart';
import 'package:shareride/utilities/app_text_styles.dart';
import 'package:shareride/utilities/button1.dart';

class Button2 extends StatefulWidget {
  const Button2({super.key, required this.label, required this.futureFunction, required this.isActive});
  final Widget label;
  final bool isActive;
  final Future Function() futureFunction;

  @override
  State<Button2> createState() => _Button2State();
}

class _Button2State extends State<Button2> {
  late ButtonState state ;
  @override
  void initState() {
    state = widget.isActive? ButtonState.normal : ButtonState.inactive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size buttonSize = Size(MediaQuery.of(context).size.width * 0.4, 31 );
    return switch (state){
      ButtonState.loading => _loadingButton(buttonSize),
      ButtonState.error => _errorButton(buttonSize),
      ButtonState.success => _successButton(buttonSize),
      ButtonState.normal => _normalButton(buttonSize),
      ButtonState.inactive => _inactiveButton(buttonSize)
    };
  }
  
  Widget _normalButton(Size size) => GestureDetector(
    onTap: () async{
      setState(() {
        state = ButtonState.loading;
      });
      await widget.futureFunction.call().then(
        (value) {
          setState(() {
            state = ButtonState.success;
          });
        }
      ).catchError((e){
        setState(() {
          state = ButtonState.error;
        });
      });
      Future.delayed(const Duration(seconds: 3)).then(
        (value) {
          setState(() {
            state = ButtonState.normal;
          });
        }
      );
    },
    child: Container(
      constraints: BoxConstraints.tight(size),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Center(
        child: widget.label,
      ),
    ),
  );

  Widget _loadingButton(Size size) => Container(
    constraints: BoxConstraints.tight(size),
    decoration: BoxDecoration(
      color: AppColors.primary.withOpacity(0.5),
      borderRadius: BorderRadius.circular(5)
    ),
    child: Center(
      child: SizedBox(
        height: size.height - 10,
        width: size.height -10,
        child: const CircularProgressIndicator(color: Colors.white,),
      ),
    ),
  );

  Widget _errorButton (Size size) => Container(
    constraints: BoxConstraints.tight(size),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(5)
    ),
    child: Center(
      child: Text(
        'error',
        style: AppTextStyle.button2,
      ),
    ),
  );

  Widget _successButton (Size size) => Container(
    constraints: BoxConstraints.tight(size),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(5)
    ),
    child: const Center(
      child: Icon(
        Icons.check,
        color: Colors.white,
      )
    ),
  );

  Widget _inactiveButton (Size size) => Container(
    constraints: BoxConstraints.tight(size),
    decoration: BoxDecoration(
      color: AppColors.grey,
      borderRadius: BorderRadius.circular(5)
    ),
    child: Center(
      child: widget.label,
    ),
  );
}