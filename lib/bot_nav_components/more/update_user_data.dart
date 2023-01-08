import 'package:consult_24/bot_nav_components/more/widget_column.dart';
import 'package:consult_24/providers/local_storage.dart';
import 'package:consult_24/providers/update_information.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UpdateUserData extends StatefulWidget {
  UpdateUserData({Key? key}) : super(key: key);

  @override
  State<UpdateUserData> createState() => _UpdateUserDataState();
}

class _UpdateUserDataState extends State<UpdateUserData> {
  int? userRole;
  int? userId;

  @override
  void initState() {
    super.initState();
    userRole = Provider.of<LocalData>(context, listen: false).userRole;
    userId = Provider.of<LocalData>(context, listen: false).userId;

    print(userId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            height: 100.h,
            width: 100.w,
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.h,
            ),
            child: userRole == 3
                ? Consumer<UpdateInformation>(
                    builder: (BuildContext context, info, _) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            info.getProviderAddress(userId);
                          },
                          child: WidgetColumn(
                            prefixIcon: Icons.edit,
                            columnName: 'Address update',
                            route: '/addressUpdate',
                          ),
                        ),
                        WidgetColumn(
                          prefixIcon: Icons.edit,
                          columnName: 'Profile picture update',
                          route: '/profilePictureUpdate',
                        ),
                        WidgetColumn(
                          prefixIcon: Icons.edit,
                          columnName: 'Bank info update',
                          route: '/bankInfoUpdate',
                        ),
                        WidgetColumn(
                          prefixIcon: Icons.edit,
                          columnName: 'Card info update',
                          route: '/',
                        ),
                        WidgetColumn(
                          prefixIcon: Icons.edit,
                          columnName: 'Service Update',
                          route: '/',
                        ),
                        WidgetColumn(
                          prefixIcon: Icons.edit,
                          columnName: 'Appointment Reschedule',
                          route: '/',
                        ),
                      ],
                    );
                  })
                : Column(
                    children: [
                      WidgetColumn(
                        prefixIcon: Icons.edit,
                        columnName: 'Address update',
                        route: '/',
                      ),
                      WidgetColumn(
                        prefixIcon: Icons.edit,
                        columnName: 'Profile picture update',
                        route: '/',
                      ),
                      WidgetColumn(
                        prefixIcon: Icons.edit,
                        columnName: 'Bank info update',
                        route: '/',
                      ),
                      WidgetColumn(
                        prefixIcon: Icons.edit,
                        columnName: 'Card info update',
                        route: '/',
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
