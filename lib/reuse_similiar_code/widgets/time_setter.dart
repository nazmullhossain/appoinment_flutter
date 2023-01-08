import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeField extends StatefulWidget {
  TextEditingController? timeInPut = TextEditingController();
  String? label;

  TimeField({
    @required this.timeInPut,
    @required this.label,
  });

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.timeInPut,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.access_time_rounded),
        labelText: '${widget.label}',
        fillColor: Colors.grey[50],
        filled: true,
      ),
      readOnly: true,
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          DateTime parsedTime = DateFormat.jm()
              .parse(pickedTime.format(context))
              .toUtc()
              .toLocal();
          String formattedTime = DateFormat('HH:mm').format(parsedTime);

          // timeInPut.text = formattedTime;

          setState(() {
            widget.timeInPut?.text = formattedTime;
          });
        }
      },
    );
  }
}
