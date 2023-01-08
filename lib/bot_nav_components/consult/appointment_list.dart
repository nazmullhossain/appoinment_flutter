import 'package:consult_24/providers/appointment.dart';
import 'package:consult_24/reuse_similiar_code/widgets/appointment_list_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AppointmentList extends StatelessWidget {
  int serialNum = 1;
  @override
  Widget build(BuildContext context) {
    print('appointment list building');
    return SafeArea(
      child: Center(
        child: SizedBox(
          height: 78.h,
          width: 100.w,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 5.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(
                    color: Colors.black87,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 19.w,
                      child: Center(
                        child: Text(
                          'Type',
                          style: TextStyle(
                            fontSize: 2.h,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 19.w,
                      child: Center(
                        child: Text(
                          'StartTime',
                          style: TextStyle(
                            fontSize: 2.h,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 19.w,
                      child: Center(
                        child: Text(
                          'EndTime',
                          style: TextStyle(
                            fontSize: 2.h,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 19.w,
                      child: Center(
                        child: Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 2.h,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 19.w,
                      child: Center(
                        child: Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 2.h,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 65.h,
                    child: Consumer<Appointment>(
                      builder: (context, appointment, child) {
                        return SizedBox(
                          height: 64.h,
                          child: ListView.builder(
                            itemCount: appointment.appointmentsList.length,
                            itemBuilder: (context, index) {
                              // int i = 1;

                              return AppointmentListBuilder(
                                // numbering: i += i,
                                type: appointment.appointmentType[index],
                                startTime:
                                    appointment.appointmentStartTime[index],
                                endTime: appointment.appointmentEndTime[index],
                                status: appointment.appointmentStatus[index],
                                date: appointment.appointmentDate[index],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          // child: Column(
          //   children: const [
          //     SizedBox(
          //       height: 80,
          //     ),
          //     Icon(
          //       Icons.today_rounded,
          //       color: Colors.blueGrey,
          //       size: 90,
          //     ),
          //     SizedBox(
          //       height: 18,
          //     ),
          //     Text(
          //       'No schedule for today!',
          //       style: TextStyle(
          //         fontFamily: 'Roboto',
          //         fontSize: 28,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }
}
