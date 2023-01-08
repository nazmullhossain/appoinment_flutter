// built in flutter packages

import 'package:consult_24/providers/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';
// import 'package:http/http.dart' as http;

// downloaded packages

import '../pages/my_consult.dart';

// manageable providers

// manageable pages
import '../pages/more_page.dart';
import '../pages/payment_page.dart';
import '../pages/chat_page.dart';
import '../pages/explore_page.dart';

// The state of homescreen must be change when user want to. so....
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<LocalData>(context, listen: false).getLocalData();
    setState(() {
      userId = Provider.of<LocalData>(context, listen: false).userId;
      debugPrint('Login Id: $userId');
    });
  }

  int? userId;

  var _selectedIndex = 0;

  final List<Widget> _pages = [
    ExplorePages(),
    MyConsultency(),
    ChatPage(),
    AppoinmentPage(),
    MorePage(),
  ];

  _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        iconSize: 4.h,
        selectedFontSize: 2.h,
        unselectedFontSize: 2.7.h,
        showSelectedLabels: true,
        selectedIconTheme: Theme.of(context).iconTheme,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
            // backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_outlined),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_rounded),
            label: 'More',
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
