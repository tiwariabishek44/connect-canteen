import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/models/wallet_model.dart';
import 'package:connect_canteen/app/modules/common/wallet/controller.dart';
import 'package:connect_canteen/app/widget/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BalanceLoadPage extends StatefulWidget {
  final String name;
  final String id;
  final String oldBalance;

  BalanceLoadPage({
    required this.oldBalance,
    required this.name,
    required this.id,
  });

  @override
  _BalanceLoadPageState createState() => _BalanceLoadPageState();
}

class _BalanceLoadPageState extends State<BalanceLoadPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final WalletController walletController = Get.put(WalletController());

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _proceed() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text);
      if (amount != null) {
        // Perform the action to load the balance
        print('Proceeding with amount: \$${amount.toStringAsFixed(2)}');
        // Navigate back or show success message
      }
    }
  }

  void _cancel() {
    // Handle cancel action
    print('Cancel loading balance');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  size: 26.sp,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ),
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Load Balance',
          style: AppStyles.appbar,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.topLeft, child: Text("Name")),
              SizedBox(
                height: 1.h,
              ),
              TextFormField(
                initialValue: widget.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              SizedBox(height: 20),
              Align(alignment: Alignment.topLeft, child: Text("UserId")),
              SizedBox(
                height: 1.h,
              ),
              TextFormField(
                initialValue: widget.id,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              SizedBox(height: 20),
              Align(alignment: Alignment.topLeft, child: Text("Amount")),
              SizedBox(
                height: 1.h,
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0.0',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    DateTime now = DateTime.now();
                    NepaliDateTime nepaliDateTime =
                        NepaliDateTime.fromDateTime(now);

                    await walletController
                        .addTransaction(
                      "${widget.id}",
                      Transactions(
                        date: nepaliDateTime,
                        name: 'load', // or penalty
                        amount: double.parse(_amountController.text.trim()),
                        remarks: "${widget.oldBalance}",
                      ),
                    )
                        .then((value) {
                      Get.back();
                      showDialog(
                          barrierColor:
                              Color.fromARGB(255, 73, 72, 72).withOpacity(0.5),
                          context: Get.context!,
                          builder: (BuildContext context) {
                            return CustomPopup(
                              message: 'Succesfully  Load Balance ',
                              onBack: () {
                                Get.back();
                              },
                            );
                          });
                    });
                  },
                  child: Container(
                    width: 90.w,
                    height: 7.h,
                    color: Color.fromARGB(255, 33, 132, 219),
                    child: Obx(() => Center(
                        child: walletController.transctionAdd.value
                            ? CircularProgressIndicator()
                            : Text(
                                "Proceed",
                                style: AppStyles.buttonText,
                              ))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
