import 'dart:async';

import 'package:consult_24/providers/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// editable widgets

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int? userId;
  @override
  void initState() {
    super.initState();
    Provider.of<LocalData>(context, listen: false).getLocalData();
  }

  @override
  void didChangeDependencies() {
    userId = Provider.of<LocalData>(context, listen: false).userId;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(
            vertical: 0.5.h,
          ),
          height: 100.h,
          width: 100.w,
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 241, 234, 234),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 3.w,
                          ),
                          child: Text(
                            'Messages',
                            style: TextStyle(
                                fontSize: 3.h,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.only(
                          right: 2.w,
                        ),
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.plus,
                          color: Colors.blueGrey,
                          size: 3.h,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Icon(
                  FontAwesomeIcons.commentSms,
                  color: Colors.greenAccent[700],
                  size: 9.h,
                ),
                SizedBox(
                  height: 1.4.h,
                ),
                Text(
                  'No messages yet',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 4.h,
                    letterSpacing: 0.01.w,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 0.8.h,
                ),
                Text(
                  'Start your conversation with expert \n and get your knowledge.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 2.5.h,
                    letterSpacing: 0.01.w,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.2.h,
                    ),
                    child: Text(
                      'Start a conversation',
                      style: TextStyle(
                        fontSize: 2.7.h,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.01.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                    side: const BorderSide(
                      width: 1,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
