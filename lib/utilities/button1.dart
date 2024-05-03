import 'package:flutter/material.dart';
import 'package:shareride/utilities/app_colors.dart';
import 'package:shareride/utilities/app_text_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton ({super.key, required this.label, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: switch(state){
        ButtonState.loading => loadingButton,
        ButtonState.error => errorButton,
        ButtonState.success => successButton,
        ButtonState.normal => normalButton,
        ButtonState.inactive => normalButton
      },
    );
  }

  final Size buttonSize = const Size(double.maxFinite, 40);

  final int waitingTime = 2;

  Widget get normalButton => Container(
    margin: const EdgeInsets.symmetric(
      // horizontal: horizontalPadding
    ),
    decoration: BoxDecoration(
      color: AppColors.mainBlue,
      borderRadius: BorderRadius.circular(5)
    ),
    constraints: BoxConstraints.tight(buttonSize),
    child: Center(
      child: Text(
        label,
        style: AppTextStyle.button1,
      ),
    ),
  );

  Widget get errorButton => Container(
    margin: const EdgeInsets.symmetric(
      // horizontal: horizontalPadding
    ),    
    decoration: BoxDecoration(
      color: AppColors.errorRed,
      borderRadius: BorderRadius.circular(5)
    ),
    constraints: BoxConstraints.tight(buttonSize),
    child: Center(
      child: Text(
        'error!',
        style: AppTextStyle.button1,
      ),
    ),
  );

  Widget get loadingButton => Container(
    color: AppColors.mainBlue.withOpacity(0.5),
    constraints: BoxConstraints.tight(buttonSize),
    child: Center(
      child: SizedBox(
        height: buttonSize.height - 10,
        width: buttonSize.height - 10,
        child: const CircularProgressIndicator(
          color: Colors.white,
        ),
      )
    ),
  );

  Widget get successButton => Container(
    color: AppColors.mainBlue,
    constraints: BoxConstraints.tight(buttonSize),
    child: Center(
      child: Text(
        'Successful!',
        style: AppTextStyle.button1
      ),
    ),
  );

  final String label;
  final ButtonState state;
}

enum ButtonState {inactive, loading, error, success, normal}
