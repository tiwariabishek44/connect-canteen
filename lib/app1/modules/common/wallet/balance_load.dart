import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:connect_canteen/app1/widget/custom_text_field.dart';
import 'package:connect_canteen/app1/widget/textFormField.dart';
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
              SizedBox(height: 20),
              CustomButton(
                  text: 'Load',
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    NepaliDateTime nepaliDateTime =
                        NepaliDateTime.fromDateTime(now);

                    Get.back();
                  },
                  isLoading: false),
            ],
          ),
        ),
      ),
    );
  }
}
