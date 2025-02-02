import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:takyeem/features/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();
  final _formKey = GlobalKey<FormBuilderState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Gap(32),
          const Gap(32),
          FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "تسجيل الدخول",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Gap(32),
                FormBuilderTextField(
                  name: 'email',
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: _emailController,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    hintText: "البريد الإلكتروني",
                    hintTextDirection: TextDirection.rtl,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "البريد الإلكتروني مطلوب"),
                  ]),
                ),
                const Gap(32),
                FormBuilderTextField(
                  name: 'password',
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: _passwordController,
                  obscureText: true,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    hintText: "كلمة المرور",
                    hintTextDirection: TextDirection.rtl,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "كلمة المرور مطلوبة"),
                  ]),
                ),
                const Gap(32),
                SizedBox(
                  width: double
                      .infinity, // This will make the button take full width
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        await login();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 7,
                      shadowColor:
                          Colors.grey.withOpacity(0.5), // Set the shadow color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the border radius
                      ),
                    ),
                    child: Text("تسجيل الدخول",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                            )),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
