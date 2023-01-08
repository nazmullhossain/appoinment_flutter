import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../widgets/dropdown_menu.dart';
import '../widgets/text_input_field.dart';

class AddressInformation extends StatelessWidget {
  TextEditingController? stateName = TextEditingController();
  TextEditingController? zipCode = TextEditingController();
  TextEditingController? cityName = TextEditingController();
  TextEditingController? streetAddress = TextEditingController();
  TextEditingController? apartmentAddress = TextEditingController();

  String? selectedCountry;
  List<String> countryName = ['Bangladesh', 'USA'];

  AddressInformation({
    @required this.stateName,
    @required this.zipCode,
    @required this.cityName,
    @required this.streetAddress,
    @required this.apartmentAddress,
    @required this.selectedCountry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      width: 100.w,
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: 1.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Address :',
              style: TextStyle(
                fontSize: 2.5.h,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.05.w,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          DropDownMenu(
            selectedItem: selectedCountry,
            itemNames: countryName,
            dropDownTitle: 'Select your country',
            dropDownWidth: 32.w,
          ),
          SizedBox(
            height: 2.h,
          ),
          TextInputField(
            label: 'State',
            icon: Icons.local_activity,
            readPermit: false,
            keyboard: TextInputType.name,
            textController: stateName,
            validateFunction: (value) {
              value = stateName?.text;
              if (value == '') {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          TextInputField(
            label: 'Zip Code',
            icon: Icons.location_on,
            keyboard: TextInputType.number,
            readPermit: false,
            textController: zipCode,
            validateFunction: (value) {
              value = zipCode?.text;
              if (value == '') {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          TextInputField(
            label: 'City',
            icon: Icons.location_city,
            readPermit: false,
            keyboard: TextInputType.name,
            textController: cityName,
            validateFunction: (value) {
              value = cityName?.text;
              if (value == '') {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          TextInputField(
            label: 'Street address',
            icon: Icons.edit_road,
            readPermit: false,
            keyboard: TextInputType.streetAddress,
            textController: streetAddress,
            validateFunction: (value) {
              value = streetAddress?.text;
              if (value == '') {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          TextInputField(
            label: 'Apartment address',
            icon: Icons.apartment,
            readPermit: false,
            keyboard: TextInputType.streetAddress,
            textController: apartmentAddress,
            validateFunction: (value) {
              value = apartmentAddress?.text;
              if (value == '') {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }
}
