import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DropDownMenu extends StatefulWidget {
  DropDownMenu({
    @required this.selectedItem,
    @required this.itemNames,
    this.dropDownTitle,
    @required this.dropDownWidth,
  });

  String? selectedItem;
  List? itemNames = [];
  double? dropDownWidth;
  String? dropDownTitle;

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.dropDownTitle.toString(),
          style: TextStyle(
            color: Colors.grey[700],
            letterSpacing: 0.03.w,
          ),
        ),
        SizedBox(
          width: 2.w,
        ),
        SizedBox(
          width: widget.dropDownWidth,
          child: DropdownButtonFormField<String>(
            value: widget.selectedItem,
            items: widget.itemNames
                ?.map(
                  (item) => DropdownMenuItem<String>(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 2.h,
                        color: Colors.grey[700],
                      ),
                    ),
                    value: item,
                  ),
                )
                .toList(),
            onChanged: (item) {
              setState(() {
                item = widget.selectedItem;
              });
            },
          ),
        ),
      ],
    );
  }
}
