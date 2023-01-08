import 'package:consult_24/providers/local_storage.dart';
import 'package:consult_24/providers/user_bank_details.dart';
import 'package:consult_24/reuse_similiar_code/widgets/bank_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UpdateBankInfo extends StatefulWidget {
  @override
  State<UpdateBankInfo> createState() => _UpdateBankInfoState();
}

class _UpdateBankInfoState extends State<UpdateBankInfo> {
  bool isLoading = true;

  int? userId;

  TextEditingController bankName = TextEditingController();
  TextEditingController bankAccName = TextEditingController();
  TextEditingController bankAccNumber = TextEditingController();
  TextEditingController bankBranchName = TextEditingController();
  @override
  void initState() {
    super.initState();
    userId = Provider.of<LocalData>(context, listen: false).userId;
    if (userId != null) {
      Provider.of<UserBankDetails>(context, listen: false)
          .getProviderBank(userId)
          .then((value) {
        if (value.statusCode == 200) {
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            Navigator.pop(context);
          });
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    var bank = Provider.of<UserBankDetails>(context, listen: false);
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
          child: isLoading == true
              ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary)
              : Container(
                  height: 100.h,
                  width: 100.w,
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 1.h,
                  ),
                  child: Consumer<UserBankDetails>(
                    builder: (context, bankDetails, child) {
                      return ListView.builder(
                        itemCount: bankDetails.bankList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 10.h,
                            width: 80.w,
                            child: ListTile(
                              title: Text(
                                bankDetails.bankAccName?[index],
                              ),
                              enabled: true,
                              subtitle: Text(
                                bankDetails.bankAccNumber?[index],
                              ),
                              trailing: Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (bankDetails.bankList.isNotEmpty) {
                                        bankName = bankDetails.bankName?[index];
                                        bankAccName =
                                            bankDetails.bankAccName?[index];
                                        bankAccNumber =
                                            bankDetails.bankAccNumber?[index];
                                        bankBranchName =
                                            bankDetails.bankBranchName?[index];
                                      }

                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: Container(
                                              height: 94.h,
                                              width: 94.w,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 1.5.w,
                                                  vertical: 1.5.h),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3.w,
                                                  vertical: 3.h),
                                              child: BankInfo(
                                                bankName: bankName,
                                                bankAccName: bankAccName,
                                                bankAccNumber: bankAccNumber,
                                                bankBranchName: bankBranchName,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('Update'),
                                  ),
                                  SizedBox(width: 0.5.w),
                                  ElevatedButton(
                                    onPressed: () {
                                      bankDetails.deleteProviderBank(userId);
                                    },
                                    child: const Text('Delete'),
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
