import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'register_screen.dart';
import 'shell.dart';
import '../widgets/app_bar_actions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _submit() async {
    if (_form.currentState!.validate()) {
      try {
        await Provider.of<AppState>(context, listen: false).login(
          _email.text.trim(),
          _password.text,
        );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Shell()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${e.toString()}')),
          );
        }
      }
    }
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AppState>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: const [AppBarActions()],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading) const LinearProgressIndicator(),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                    ),
                    validator: _req,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                    ),
                    validator: _req,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text('Create an account'),
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
