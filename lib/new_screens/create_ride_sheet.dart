import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shareride/new_screens/join_bottom_sheet.dart';

import '../models/location.dart';
import '../providers/locations_provider.dart';
import '../providers/rides_provider.dart';
import '../providers/service_time_provider.dart';
import '../providers/user_provider.dart';
import '../utilities/app_colors.dart';
import '../utilities/app_snackbar.dart';
import '../utilities/button1.dart';
import '../utilities/form_decoration.dart';

class CreateRideFormSheet extends StatefulWidget {
  const CreateRideFormSheet({
    super.key, required this.locations,
  });
  final List<Location> locations;

  @override
  State<CreateRideFormSheet> createState() => _CreateRideFormSheetState();
}

class _CreateRideFormSheetState extends State<CreateRideFormSheet> {
  
  final TextEditingController _nameController = TextEditingController();
  Location? _fromValue;
  Location? _toValue;
  List<Location> _toList = [];
  String? _timeValue;
  final _createRideFormKey = GlobalKey<FormState>();
  var buttonState = ButtonState.normal;
  toggleButtonState (ButtonState state) {
    setState(() {
      buttonState = state;
    });
  }

  Widget get _space => SizedBox(height: 32.h,);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: SizedBox()),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 24.h),
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromRGBO(158, 158, 158, 1),
              width: 0.2
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)
            ),
            
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Create Ride',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400
                ),
              ),        
              _space,              
              Form(
                key: _createRideFormKey,
                child: Column(
                  children: [
                    AppFormDecoration.dropdownFormfield(
                      'Coming from', 
                      'Chizaram Lodge, Hilltop', 
                      widget.locations.where(
                        (element) => element.isRoute == false 
                        // && element.region.toLowerCase() == widget.regionRide.region.toLowerCase()
                      ).toList(), 
                      _fromValue, 
                      (p0) {
                        setState(() {
                          _fromValue = p0;
                          _toList = context.read<LocationsProvider>().locations.where(
                            (e) => e.isInsideSchool == !p0!.isInsideSchool && e.isRoute
                            ).toList();
                        });
                      },
                      (){
                        setState(() {
                          _toValue = null;
                          _toList = [];
                        });
                      }
              
                    ),
                    AppFormDecoration.dropdownFormfield(
                      'Going to', 
                      'Palg, School', 
                      _toList,  
                      _toValue, 
                      (p0) {
                        setState(() {
                          _toValue = p0;
                        });
                      },
                      (){}
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Time/Schedule',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w300,
                            color: AppColors.black
                          ),            
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        DropdownButtonFormField<String?>( 
                          style: const TextStyle(fontSize: 13, color: Colors.black),
                          value: _timeValue,         
                          items: List.generate(
                            context.read<ServiceTimeProvider>().serviceTimeList.length , 
                            (index) => DropdownMenuItem(
                              value: context.read<ServiceTimeProvider>().serviceTimeList.map((e) => e.key).toList()[index],
                              child: Text(
                                context.read<ServiceTimeProvider>().serviceTimeList.map((e) => e.key).toList()[index],
                                overflow: TextOverflow.visible,
                              ),
                            )
                          ), 
                          onChanged: (p0) {
                            setState(() {
                              _timeValue = p0;
                            });
                          },          
                          validator: (s){
                            if (s == null ) {
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
                            hintText: '8am',
                            hintStyle: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.searchFieldHint,
                              
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Display name',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w300,
                            color: AppColors.black
                          ),            
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: _nameController,
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
                            hintText: 'Joshua',
                            hintStyle: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.searchFieldHint,
                              
                            ),
                          ),
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'invalid field';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.name,
                        ),
                      ],
                    ),
                    _space,
        
                    GestureDetector(
                      onTap: _createRideFunction,
                      child: AppButton(
                        label: 'Create', 
                        state: buttonState,
                        height: 40.h,
                        
                      ),
                    )
              
                  ],
                ) 
              ),
            ],
          ),
        ),
      ],
    );
  }

  _createRideFunction() async{
    if (_createRideFormKey.currentState!.validate() && buttonState != ButtonState.loading) {
      toggleButtonState(ButtonState.loading);
      await context.read<RidesProvider>().createRide(
        from: _fromValue!,
        to: _toValue!,
        time: _timeValue!,
        userId: context.read<UserProvider>().uid!,
        name: _nameController.text
      ).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppSnackBar.normal('New Ride Created!')
        );
        showBottomSheet(
          context: context, 
          builder: (context) => JoinBottomSheet(ride: value, context: context)
        );
      }        
      ).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(
          AppSnackBar.error(e)
        );
        toggleButtonState(ButtonState.error);
        Future.delayed(const Duration(milliseconds: 1500)).then((value) => toggleButtonState(ButtonState.normal));
      });
    }
  }
}