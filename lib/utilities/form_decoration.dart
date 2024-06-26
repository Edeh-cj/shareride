import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shareride/models/location.dart';
import 'package:shareride/utilities/app_colors.dart';
import 'package:shareride/utilities/app_text_styles.dart';

class AppFormDecoration {
  static BoxDecoration get boxDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: AppColors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 4,
          ),
        ],
      );

  static EdgeInsets get padding =>
      const EdgeInsets.only(bottom: 32, right: 32, left: 32, top: 40);

  static EdgeInsets get margin =>
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  static Widget formField(
          TextEditingController controller,
          String label,
          String? innerLabel,
          String? Function(String?)? validator,
          TextInputType keyboardType) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.formLabel,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              constraints:
                  BoxConstraints.tight(const Size(double.maxFinite, 36)),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(
                  color: Color.fromRGBO(217, 217, 217, 1),
                ),
              ),
              hintText: innerLabel,
              hintStyle: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 20)
        ],
      );

  static Widget dropdownFormfield(
          String label,
          String? innerLabel,
          List<Location> listOfValues,
          Location? fieldValue,
          Function(Location?) onChanged,
          Function() onTap) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13.sp, 
              fontFamily: 'Spartan'),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<Location?>(
            style: const TextStyle(fontSize: 13, color: Colors.black),
            value: fieldValue,
            onTap: onTap.call,
            items: List.generate(
              listOfValues.length,
              (index) => DropdownMenuItem(
                value: listOfValues[index],
                child: Text(
                  '${listOfValues[index].name}, ${listOfValues[index].region}',
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            onChanged: onChanged.call,
            validator: (s) {
              if (s == null) {
                return 'invalid field';
              } else {
                return null;
              }
            },
            borderRadius: BorderRadius.circular(0),
            elevation: 0,
            iconSize: 12,
            decoration: InputDecoration(
              constraints: BoxConstraints.tight(
                const Size(double.maxFinite, 42),
              ),
              filled: true,
              fillColor: AppColors.backgroundFaint,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              hintText: innerLabel,
              hintStyle: TextStyle(
                fontSize: 10,
                color: AppColors.searchFieldHint,
                
              ),
            ),
          ),
          const SizedBox(height: 15)
        ],
      );
}
