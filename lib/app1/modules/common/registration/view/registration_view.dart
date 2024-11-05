import 'package:connect_canteen/app1/modules/common/logoin_option/login_option_controller.dart';
import 'package:connect_canteen/app1/modules/common/registration/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  RegisterView({
    super.key,
    required this.schoolName,
    required this.schoolId,
  });

  final String schoolName;
  final String schoolId;
  final registerController = Get.put(UserRegisterController());
  final loginOptionController = Get.put(LoginOptionController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, theme),
          SliverToBoxAdapter(
            child: _buildBody(context, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: true,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Account',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 4),
            Text(
              schoolName,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: false,
        titlePadding: EdgeInsets.only(left: 16, bottom: 16),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: registerController.registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputField(
              theme,
              controller: registerController.nameController,
              label: 'Full Name',
              icon: Icons.person_outline,
              hint: 'Enter your full name',
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildInputField(
              theme,
              controller: registerController.emailController,
              label: 'Email Address',
              icon: Icons.email_outlined,
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Email is required';
                }
                if (!GetUtils.isEmail(value!)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildInputField(
              theme,
              controller: registerController.mobileNumberController,
              label: 'Mobile Number',
              icon: Icons.phone_outlined,
              hint: 'Enter mobile number',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Mobile number is required';
                }
                if (value!.length < 10) {
                  return 'Enter a valid mobile number';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Obx(() => _buildInputField(
                  theme,
                  controller: registerController.passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  hint: 'Create a password',
                  obscureText: !registerController.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      registerController.isPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: () =>
                        registerController.isPasswordVisible.toggle(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Password is required';
                    }
                    if (value!.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                )),
            SizedBox(height: 24),
            _buildTermsAndConditions(theme),
            SizedBox(height: 24),
            _buildRegisterButton(context, theme),
            SizedBox(height: 16),
            _buildLoginPrompt(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    ThemeData theme, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: theme.colorScheme.primary),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions(ThemeData theme) {
    return Obx(() => Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: registerController.termsAndConditions.value,
                onChanged: (value) =>
                    registerController.termsAndConditions.toggle(),
                activeColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: 'I agree to the ',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildRegisterButton(BuildContext context, ThemeData theme) {
    return Obx(() => ElevatedButton(
          onPressed: registerController.isRegisterLoading.value
              ? null
              : () {
                  if (registerController.registerFormKey.currentState!
                      .validate()) {
                    if (!registerController.termsAndConditions.value) {
                      Get.snackbar(
                        'Error',
                        'Please accept the terms and conditions',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: theme.colorScheme.error,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    registerController.userRegister(
                      context,
                      schoolName,
                      schoolId,
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: registerController.isRegisterLoading.value
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ));
  }

  Widget _buildLoginPrompt(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Login',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
