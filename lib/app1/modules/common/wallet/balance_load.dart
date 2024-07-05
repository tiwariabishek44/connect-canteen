import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/canteen_main_screen/canteen_main_screen.dart';
import 'package:connect_canteen/app1/modules/common/wallet/transcton_controller.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/balance_card.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:connect_canteen/app1/widget/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BalanceLoadPage extends StatefulWidget {
  final String name;
  final String id;
  final String oldBalance;
  final String grade;

  BalanceLoadPage({
    required this.grade,
    required this.oldBalance,
    required this.name,
    required this.id,
  });

  @override
  _BalanceLoadPageState createState() => _BalanceLoadPageState();
}

class _BalanceLoadPageState extends State<BalanceLoadPage> {
  final transctionContorller = Get.put(TransctionController());
  final TextEditingController _amountController = TextEditingController();
  late final TextEditingController _nameController;
  late final TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _idController = TextEditingController(text: widget.id);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime nowUtc = DateTime.now().toUtc();
    DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
    final transctionDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";

    final transctionTime = DateFormat('HH:mm\'', 'en').format(nowNepal);

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
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: transctionContorller.balanceFormKey,
              child: ListView(
                children: [
                  BalanceCard(
                    userid: widget.id,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TextFormFieldWidget(
                    readOnly: true,
                    showIcons: false,
                    textInputType: TextInputType.text,
                    hintText: "Name",
                    controller: _nameController,
                    validatorFunction: (value) {
                      if (value.isEmpty) {
                        return "Email is required";
                      }
                      return null;
                    },
                    actionKeyboard: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  TextFormFieldWidget(
                    readOnly: true,
                    showIcons: false,
                    textInputType: TextInputType.text,
                    hintText: "UserId",
                    controller: _idController,
                    validatorFunction: (value) {
                      return null;
                    },
                    actionKeyboard: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  TextFormFieldWidget(
                    readOnly: false,
                    showIcons: false,
                    textInputType: TextInputType.number,
                    hintText: "Amount",
                    controller: _amountController,
                    validatorFunction: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                    actionKeyboard: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  SizedBox(height: 3.h),
                  Obx(() => CustomButton(
                      text: 'Load',
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        await transctionContorller.loadWallet(
                          double.parse(_amountController.text),
                          widget.id,
                          widget.name,
                          widget.grade,
                        );
                      },
                      isLoading: transctionContorller.orderLoading.value)),
                  SizedBox(
                    height: 4.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        Get.offAll(() => CanteenMainScreen());
                      },
                      child: Container(
                        height: 5.5.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 139, 137, 137),
                          ),
                          color: const Color.fromARGB(255, 232, 227, 227),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'Go To Dahsboard',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 30.h,
              left: 50.w,
              child: Obx(() => transctionContorller.transctionUploading.value
                  ? LoadingWidget()
                  : SizedBox.shrink()))
        ],
      ),
    );
  }
}
