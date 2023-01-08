import 'dart:async';

import 'package:consult_24/models/call_api.dart';
import 'package:consult_24/reuse_similiar_code/widgets/date_picker.dart';
import 'package:consult_24/reuse_similiar_code/widgets/text_input_field.dart';
import 'package:consult_24/reuse_similiar_code/widgets/time_setter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AppointmentSchedule extends StatefulWidget {
  bool value = false;

  @override
  State<AppointmentSchedule> createState() => _AppointmentScheduleState();
}

class _AppointmentScheduleState extends State<AppointmentSchedule> {
  bool isLoading = false;

  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController duration = TextEditingController();

  TextEditingController selectDays = TextEditingController();

  var values = List.filled(7, false);

  @override
  void initState() {
    super.initState();
  }

  var weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  Future createAppointmentSchedule() async {
    isLoading = true;

    var formData = FormData.fromMap({
      'saturday': values[6].toString(),
      'sunday': values[0].toString(),
      'monday': values[1].toString(),
      'tuesday': values[2].toString(),
      'wednesday': values[3].toString(),
      'thursday': values[4].toString(),
      'friday': values[5].toString(),
      'all': 'false',
      'day_start_time': startTime.text,
      'day_end_time': endTime.text,
      'appointment_start_date': startDate.text,
      'appointment_end_date': endDate.text,
      'duration': duration.text,
    });

    try {
      var providerAppointmentResponse = await CallApi()
          .createSchedule(formData, '/api/provider_appointment_create/');

      debugPrint('${providerAppointmentResponse.statusCode}');

      if (providerAppointmentResponse.statusCode == 201) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Appointment create successfull"),
            ),
          );

          Navigator.pushReplacementNamed(context, '/homeScreen');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Appointment create failed"),
          ),
        );
      }
    } catch (error) {
      debugPrint('Provider Appointment create error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            height: 100.h,
            width: 100.w,
            margin: EdgeInsets.symmetric(
              vertical: 1.h,
              horizontal: 2.w,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Appointment create',
                    style: TextStyle(
                      color: const Color.fromARGB(174, 0, 0, 0),
                      fontSize: 2.5.h,
                      letterSpacing: 0.05.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title('Period of giving service:'),
                      SizedBox(
                        height: 2.h,
                      ),
                      DateField(
                        startingDate: DateTime.now(),
                        finishingDate: DateTime(2099),
                        dateController: startDate,
                        label: 'Start Date',
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      DateField(
                        startingDate: DateTime.now(),
                        finishingDate: DateTime(2099),
                        dateController: endDate,
                        label: 'End Date',
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      title('Available Days:'),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        height: 10.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: WeekdaySelector(
                            onChanged: (i) {
                              setState(() {
                                values[i % 7] = !values[i % 7];
                              });
                            },
                            values: values,
                            elevation: 05,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      title('Available Times:'),
                      SizedBox(height: 2.h),
                      TimeField(
                        timeInPut: startTime,
                        label: 'Start time',
                      ),
                      SizedBox(height: 1.h),
                      TimeField(
                        timeInPut: endTime,
                        label: 'End time',
                      ),
                      SizedBox(height: 4.h),
                      title('Duration of Appointment:'),
                      SizedBox(height: 2.h),
                      TextInputField(
                        readPermit: false,
                        icon: Icons.timelapse,
                        keyboard: TextInputType.number,
                        label: 'Duration (mint)',
                        textController: duration,
                      ),
                      SizedBox(height: 5.h),
                      Center(
                        child: isLoading == true
                            ? CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            : ElevatedButton(
                                onPressed: createAppointmentSchedule,
                                child: Text(
                                  'Create Schedule',
                                  style: TextStyle(
                                    fontSize: 1.7.h,
                                    letterSpacing: 0.05.w,
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  title(String? title) => Text(
        '$title',
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 1.8.h,
          letterSpacing: 0.05.w,
        ),
      );
}
