import 'package:consult_24/reuse_similiar_code/widgets/dropdown_menu.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../bot_nav_components/consult/appointment_list.dart';
import '../bot_nav_components/consult/notifications.dart';
import '../providers/appointment.dart';
import '../providers/local_storage.dart';

class MyConsultency extends StatefulWidget {
  @override
  State<MyConsultency> createState() => _MyConsultencyState();
}

class _MyConsultencyState extends State<MyConsultency>
    with TickerProviderStateMixin {
  late TabController _tabController;

  var pages = [
    AppointmentList(),
    Notifications(),
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    // _pageController = PageController(initialPage: 0);
    super.initState();
    Provider.of<Appointment>(context, listen: false).getAllAppointmentList(
        Provider.of<LocalData>(context, listen: false).userId);
    _tabController = TabController(length: pages.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String? dropDownTitle = 'Sort result';
  List itemNames = [
    'All',
    'By Date',
    'By Type',
    'By status',
    'By service name'
  ];
  String? selectedItem;

  TextEditingController? dateController;

  sortingByDate() async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        dateController?.text = formattedDate;
      });
    } else {
      setState(() {
        dateController?.text = 'No date selected';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              width: 100.w,
              height: 7.h,
              // decoration: const BoxDecoration(
              //   color: Color.fromARGB(255, 241, 234, 234),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  // Text(
                  //   'My consultency',
                  //   style: TextStyle(
                  //     fontSize: 3.h,
                  //     letterSpacing: 0.03.w,
                  //     color: Colors.grey,
                  //     fontFamily: 'Roboto',
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'All previews',
                  //       style: TextStyle(
                  //         fontSize: 2.5.h,
                  //         letterSpacing: 0.02.w,
                  //         fontFamily: 'Roboto',
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //     IconButton(
                  //       onPressed: () {},
                  //       icon: Icon(
                  //         FontAwesomeIcons.angleDown,
                  //         size: 2.5.h,
                  //         color: Colors.blueGrey,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  //   ],
                  // ),
                  // DropDownMenu(
                  //   dropDownTitle: dropDownTitle,
                  //   selectedItem: selectedItem.toString(),
                  //   itemNames: itemNames,
                  //   dropDownWidth: 35.w,
                  // ),
                  TabBar(
                    automaticIndicatorColorAdjustment: true,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    labelColor: Colors.black,
                    unselectedLabelColor:
                        Theme.of(context).colorScheme.secondary,
                    indicatorWeight: 4,
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: Text(
                          'Appointment List',
                          style: TextStyle(
                            fontSize: 4.w,
                            letterSpacing: 0.02.w,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            letterSpacing: 0.02.w,
                            fontSize: 4.w,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: pages,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPageNavigation(String navigateName, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          // print(index);
        });
      },
      child: Container(
        child: Text(
          navigateName,
          textAlign: TextAlign.center,
        ),
        height: 2.h,
        width: MediaQuery.of(context).size.width / 3.5,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: MediaQuery.of(context).size.width * 0.00004,
              color: index == _selectedIndex ? Colors.orange : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  openDropDown() {}
}
