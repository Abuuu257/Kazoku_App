import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'shell.dart';
import '../widgets/app_bar_actions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  void _submit() async {
    if (_form.currentState!.validate()) {
      if (_password.text != _confirm.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }
      
      try {
        await Provider.of<AppState>(context, listen: false).register(
          _name.text.trim(),
          _username.text.trim(),
          _email.text.trim(),
          _password.text,
        );
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Shell()),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AppState>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Register'), actions: const [AppBarActions()]),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading) const LinearProgressIndicator(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      validator: _req,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _username,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: _req,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: _req,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: _req,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirm,
                      decoration: const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _req,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isLoading ? null : _submit,
                        child: const Text('Create account'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back to Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
