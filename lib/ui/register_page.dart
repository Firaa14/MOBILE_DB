import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/validators.dart';
import '../providers/auth_provider.dart';
import 'widgets/app_text_field.dart';
import 'widgets/app_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: _email,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _pass,
                    label: 'Password',
                    obscure: true,
                    validator: (v) => Validators.password(v, min: 6),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _confirm,
                    label: 'Konfirmasi Password',
                    obscure: true,
                    validator: (v) => Validators.confirm(v, _pass.text),
                  ),
                  const SizedBox(height: 16),
                  if (auth.error != null)
                    Text(
                      auth.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 8),
                  AppButton(
                    text: 'Daftar',
                    loading: _submitting,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      setState(() => _submitting = true);
                      final ok = await context.read<AuthProvider>().register(
                        _email.text.trim(),
                        _pass.text,
                      );
                      setState(() => _submitting = false);
                      if (ok && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registrasi berhasil')),
                        );
                        Navigator.pop(context); // kembali ke Login
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(auth.error ?? 'Gagal daftar')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
