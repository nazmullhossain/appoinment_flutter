import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  final values = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: values.isEmpty
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 1.00,
              child: Column(
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Icon(
                    Icons.check_circle,
                    size: 90,
                    color: Colors.greenAccent[700],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'You are all caught up!',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Check back later for udate on your projects.',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Container(
                  height: 50,
                  color: Colors.amber[600],
                  child: const Center(child: Text('Entry A')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry B')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[100],
                  child: const Center(child: Text('Entry C')),
                ),
              ],
            ),
    );
  }
}
