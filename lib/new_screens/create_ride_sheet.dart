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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h, 
      width: double.maxFinite,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, -2)
          )
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15)
        ),
        
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 15.h,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0.h),
                child: Icon(
                  Icons.drag_handle,
                  color: AppColors.mainBlue,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    const Padding(
                      padding: EdgeInsets.only(top: 30.0, left: 24),
                      child: Text(
                        'Create New Ride',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        )
                      ),
                    ),
                    
                    Padding(
                      padding: AppFormDecoration.padding,
                      child: Form(
                        key: _createRideFormKey,
                        child: Column(
                          children: [
                            AppFormDecoration.dropdownFormfield(
                              'From', 
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
                              'To', 
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
                                const Text(
                                  'Time',
                                  style: TextStyle(
                                    fontSize: 13
                                  ),            
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                DropdownButtonFormField<String?>( 
                                  style: const TextStyle(fontSize: 13, color: Colors.black),
                                  value: _timeValue,         
                                  items: List.generate(
                                    context.read<ServiceTimeProvider>().timeData.keys.toList().length , 
                                    (index) => DropdownMenuItem(
                                      value: context.read<ServiceTimeProvider>().timeData.keys.toList()[index],
                                      child: Text(
                                        context.read<ServiceTimeProvider>().timeData.keys.toList()[index],
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
                                      const Size(double.maxFinite, 36)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(217, 217, 217, 1)
                                      )
                                    ),
                                    hintText: '8am',
                                    hintStyle: const TextStyle(
                                      fontSize: 13,
                                    )
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                )
                              ],
                            ),
                            AppFormDecoration.formField(
                              _nameController, 
                              'Display Name', 
                              null, 
                              (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'invalid field';
                                } else {
                                  return null;
                                }
                              },
                              TextInputType.name
                            ),

                            GestureDetector(
                              onTap: _createRideFunction,
                              child: AppButton(
                                label: 'Create', 
                                state: buttonState,
                                
                              ),
                            )
          
                          ],
                        ) 
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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