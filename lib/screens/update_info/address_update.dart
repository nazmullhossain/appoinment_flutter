import 'package:consult_24/providers/local_storage.dart';
import 'package:consult_24/providers/update_information.dart';
import 'package:consult_24/reuse_similiar_code/form/address_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddressUpdate extends StatefulWidget {
  AddressUpdate({Key? key}) : super(key: key);

  @override
  State<AddressUpdate> createState() => _AddressUpdateState();
}

class _AddressUpdateState extends State<AddressUpdate> {
  bool isInit = true;

  int? userId;

  TextEditingController stateName = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController cityName = TextEditingController();
  TextEditingController streetAddress = TextEditingController();
  TextEditingController apartmentAddress = TextEditingController();
  String? selectedCountry;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<LocalData>(context, listen: false).userId;
    Provider.of<UpdateInformation>(context, listen: false)
        .getProviderAddress(userId)
        .then((value) {
      if (value.statusCode == 200) {
        var userAddress =
            Provider.of<UpdateInformation>(context, listen: false);

        setState(() {
          stateName.text = userAddress.stateName.toString();
          zipCode.text = userAddress.zipCode.toString();
          cityName.text = userAddress.cityName.toString();
          streetAddress.text = userAddress.streetAddress.toString();
          apartmentAddress.text = userAddress.apartmentAddress.toString();
          selectedCountry = userAddress.selectedCountry;

          isInit = false;
        });
      }
    });
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: isInit == true
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              )
            : Container(
                height: 65.h,
                width: 100.w,
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: 1.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AddressInformation(
                        stateName: stateName,
                        zipCode: zipCode,
                        cityName: cityName,
                        streetAddress: streetAddress,
                        apartmentAddress: apartmentAddress,
                        selectedCountry: selectedCountry,
                      ),
                      SizedBox(height: 2.h),
                      Consumer<UpdateInformation>(
                          builder: (context, info, child) {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isInit = true;
                            });
                            info.putProviderAddress(
                              userId,
                              {
                                'street_address': streetAddress.text,
                                'apt': apartmentAddress.text,
                                'zip_code': zipCode.text,
                                'city': cityName.text,
                                'state': stateName.text,
                                'country': selectedCountry.toString(),
                              },
                            ).then((value) {
                              if (value.statusCode == 200) {
                                setState(() {
                                  isInit = false;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Your address update has successfull'),
                                    ),
                                  );
                                });
                              }
                            });
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 2.h,
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
