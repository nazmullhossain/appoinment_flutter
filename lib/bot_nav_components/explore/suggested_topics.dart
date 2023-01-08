//  built in project

import 'package:flutter/material.dart';

class SuggestedTopics extends StatefulWidget {
  @override
  State<SuggestedTopics> createState() => _SuggestedTopicsState();
}

class _SuggestedTopicsState extends State<SuggestedTopics> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 15.0,
      ),
      child: Column(
        children: [
          const Text(
            'Our Popular projects',
            style: TextStyle(
              fontSize: 25.0,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 15.0,
          ),
          ListTile(
            leading: CircleAvatar(
              child: Image.asset('assets/images/cover.PNG'),
            ),
            title: const Text('This is our first project'),
            trailing: TextButton(
              child: const Text('Details'),
              onPressed: () {},
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              child: Image.asset('assets/images/cover.PNG'),
            ),
            title: const Text('This is our first project'),
            trailing: TextButton(
              child: const Text('Details'),
              onPressed: () {},
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              child: Image.asset('assets/images/cover.PNG'),
            ),
            title: const Text('This is our first project'),
            trailing: TextButton(
              child: const Text('Details'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
