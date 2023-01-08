import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatefulWidget {
  DateTime? startingDate;
  DateTime? finishingDate;

  TextEditingController? dateController = TextEditingController();

  String? label;
  String? hint;

  DateField({
    @required this.startingDate,
    @required this.finishingDate,
    @required this.dateController,
    @required this.label,
    this.hint,
  });

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      // onEditingComplete: getText,
      controller: widget.dateController,

      readOnly: true,
      onTap: () async {
        var pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: widget.startingDate as DateTime,
          lastDate: widget.finishingDate as DateTime,
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            widget.dateController?.text = formattedDate;
          });
        } else {
          setState(() {
            widget.dateController?.text = 'No date selected';
          });
        }
      },
      decoration: InputDecoration(
        labelText: '${widget.label}',
        fillColor: Colors.grey[50],
        filled: true,
        // border: InputBorder.none,
        hintText: '${widget.hint}',
        prefixIcon: const Icon(Icons.calendar_month),
      ),
    );
  }
}
