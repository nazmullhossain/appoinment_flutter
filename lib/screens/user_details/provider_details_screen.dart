import 'package:consult_24/pages/home_pages/provider_home_page.dart';

import 'package:flutter/material.dart';

// import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class ProviderDetailsScreen extends StatefulWidget {
  @override
  State<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();
}

class _ProviderDetailsScreenState extends State<ProviderDetailsScreen> {
  // const ProviderDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_sharp),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/updateUserData');
            },
            child: const Text('Edit profile'),
          ),
        ],
      ),
      body: ProviderScreen(),
    );
  }
}
