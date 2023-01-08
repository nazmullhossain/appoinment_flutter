import 'package:consult_24/models/for_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactUs extends StatefulWidget {
  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final List<String> _countrySelection = ['Bangladesh', 'USA'];

  late String? _selcetedCountry = 'Bangladesh';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          height: height,
          width: width * 1,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          padding: const EdgeInsets.fromLTRB(
            20,
            15,
            15,
            15,
          ),
          child: Column(
            children: [
              Text(
                'We are waiting',
                style: Theme.of(context).textTheme.headline4,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.only(
                  top: 20,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Select your country first',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          child: DropdownButtonFormField<String>(
                            value: _selcetedCountry,
                            items: _countrySelection
                                .map((item) => DropdownMenuItem<String>(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      value: item,
                                    ))
                                .toList(),
                            onChanged: (item) {
                              setState(
                                () {
                                  _selcetedCountry = item;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.phone_in_talk_rounded,
                              size: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Row(
                                children: [
                                  const Text('Phone: '),
                                  SizedBox(
                                    child: TextButton(
                                      child: _selcetedCountry == 'Bangladesh'
                                          ? const Text('+880 1751 666668')
                                          : const Text('+1 408 498 3634'),
                                      onPressed: () async {
                                        final Uri phoneNumber = Uri(
                                          scheme: 'tel',
                                          path: _selcetedCountry == 'Bangladesh'
                                              ? '+8801751666668'
                                              : '+14084983634',
                                        );
                                        if (await canLaunchUrlString(
                                            phoneNumber.toString())) {
                                          await launchUrlString(
                                            phoneNumber.toString(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.mail_outline_outlined,
                              size: 25,
                              // color: Theme.of(context).colorScheme.primary,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Row(
                                children: [
                                  const Text('Email: '),
                                  SizedBox(
                                    child: TextButton(
                                      child: const Text('support@accelx.net'),
                                      onPressed: () async {
                                        try {
                                          await launchUrl(emailLaunchUri);
                                        } on PlatformException {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'No email has issued in the device'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Row(
                                children: [
                                  const Text('Address: '),
                                  SizedBox(
                                    child: TextButton(
                                      child: _selcetedCountry == 'Bangladesh'
                                          ? const Text(
                                              'House: 03, Road: 14, Sector: 01, Uttara, Dhaka',
                                              softWrap: true,
                                            )
                                          : const Text(
                                              '447 Downing Ave, San Jose, CA 95128, USA',
                                              softWrap: true,
                                            ),
                                      onPressed: () async {
                                        if (_selcetedCountry == 'Bangladesh') {
                                          MapUtils.openMap(23.86038, 90.39933);
                                        } else if (_selcetedCountry == 'USA') {
                                          MapUtils.openMap(
                                              37.30552, -121.93853);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  late Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'support@accelx.net',
    query: encodeQueryParameters(
        <String, String>{'subject': 'Feedback with information'}),
  );
}
