import 'package:flutter/material.dart';
import 'package:waqti/widgets/custom_button.dart';
import 'package:waqti/widgets/custom_text_field.dart';

import 'sign_in_header.dart';
import 'sign_up_prompt.dart';

class SignInForm extends StatelessWidget {
  final bool isLoading;
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  const SignInForm({
    super.key,
    required this.isLoading,
    required this.identifierController,
    required this.passwordController,
    required this.onSignIn,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SignInHeader(),
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: identifierController,
                  label: 'Email',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  obscureText: true,
                  label: 'Password',
                ),
                const SizedBox(height: 16),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                  onPressed: onSignIn,
                  text: 'Sign In',
                ),
                const SizedBox(height: 16),
                SignUpPrompt(onSignUp: onSignUp),
                // PhoneSignInButton(isLoading: isLoading, onPressed: onSignIn),
                // const UsersList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
