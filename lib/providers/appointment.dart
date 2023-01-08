import 'dart:convert';

import 'package:consult_24/models/call_api.dart';
import 'package:flutter/widgets.dart';

class Appointment with ChangeNotifier {
  List appointmentsList = [];
  List appointmentType = [];
  List appointmentDate = [];
  List appointmentStartTime = [];
  List appointmentEndTime = [];
  List appointmentStatus = [];
  List appointmentDuration = [];
  List appointmentId = [];

  // provider appointment get
  Future getAllAppointmentList(int? providerId) async {
    appointmentDate = [];
    appointmentStartTime = [];
    appointmentEndTime = [];
    appointmentStatus = [];
    appointmentType = [];
    appointmentDuration = [];
    appointmentId = [];
    appointmentsList = [];
    try {
      final response = await CallApi()
          .getData('/api/single_provider_appointment_info/$providerId');

      appointmentsList = json.decode(response.body);

      if (response.statusCode == 200) {
        for (var i = 0; i < appointmentsList.length; i++) {
          appointmentType.add(appointmentsList[i]?['appointment_type']);
          appointmentDate.add(appointmentsList[i]?['appointment_date']);
          appointmentStartTime.add(appointmentsList[i]?['start_time']);
          appointmentEndTime.add(appointmentsList[i]?['end_time']);
          appointmentStatus.add(appointmentsList[i]?['status']);
          appointmentId.add(appointmentsList[i]?['id']);
          appointmentDuration.add(appointmentsList[i]?['duration']);
        }
      }

      notifyListeners();
      return response;
    } catch (error) {
      debugPrint('getAllAppointment error: $error');
    }
  }

  // customer appointment get
  Future customerMakeAppointmentGet() async {
    appointmentDate = [];
    appointmentStartTime = [];
    appointmentEndTime = [];
    appointmentStatus = [];
    appointmentType = [];
    appointmentDuration = [];
    appointmentId = [];
    appointmentsList = [];
    try {
      final response = await CallApi().getData('/api/CustomerAppointmentGet/');

      appointmentsList = json.decode(response.body);

      if (response.statusCode == 200) {
        for (var i = 0; i < appointmentsList.length; i++) {
          appointmentType.add(appointmentsList[i]?['appointment_type']);
          appointmentDate.add(appointmentsList[i]?['appointment_date']);
          appointmentStartTime.add(appointmentsList[i]?['start_time']);
          appointmentEndTime.add(appointmentsList[i]?['end_time']);
          appointmentId.add(appointmentsList[i]?['id']);
          appointmentDuration.add(appointmentsList[i]?['duration']);
          appointmentStatus.add(appointmentsList[i]?['status']);
          // appointmentId.add(value)
        }
      }
      notifyListeners();
      return response;
    } catch (error) {
      debugPrint('Customer get appointment : $error');
    }
  }

  // customer confirm appointment
  Future customerConfirmAppointment(
      int? appointmentId, String? appointmentType, int? customerId) async {
    var data = {
      'appointment_type': appointmentType.toString(),
      'status': 'booked',
      'appointment_customer': customerId
    };
    try {
      final response = await CallApi()
          .patchData(data, '/api/customer_appointment/$appointmentId');

      debugPrint('Customer confirm appointment: ${response.statusCode}');

      return response;
    } catch (error) {
      debugPrint('Customer Appointment Confirm eroor: $error');
    }
  }

  // service appointment availity
  Future serviceAppointmentAvaility(int? serviceId) async {
    appointmentDate = [];
    appointmentStartTime = [];
    appointmentEndTime = [];
    appointmentStatus = [];
    appointmentType = [];
    appointmentDuration = [];
    appointmentId = [];
    appointmentsList = [];
    try {
      final response = await CallApi().getData(
          '/api/CustomerCheckProviderAppointmentGetwithServiceId/?service_id=$serviceId');

      appointmentsList = json.decode(response.body);
      print('service availity: ${response.statusCode}');

      if (response.statusCode == 200) {
        for (var i = 0; i < appointmentsList.length; i++) {
          appointmentType.add(appointmentsList[i]?['appointment_type']);
          appointmentDate.add(appointmentsList[i]?['appointment_date']);
          appointmentStartTime.add(appointmentsList[i]?['start_time']);
          appointmentEndTime.add(appointmentsList[i]?['end_time']);
          appointmentStatus.add(appointmentsList[i]?['status']);
          appointmentId.add(appointmentsList[i]?['id']);
          appointmentDuration.add(appointmentsList[i]?['duration']);

          print('Appointment id: $appointmentId');
        }
      }
      notifyListeners();
      return response;
    } catch (error) {
      debugPrint('Service appointmenet availity error: $error');
    }
  }
}
