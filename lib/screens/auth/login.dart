import 'package:admin/business_logic/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginDialog extends StatefulWidget {
  @override
  LoginDialogState createState() => LoginDialogState();
}

class LoginDialogState extends State<LoginDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email",
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() => _loading = true);
    String email = _emailController.text;
    String password = _passwordController.text;

    await context.read<AuthCubit>().login(email, password);

    setState(() => _loading = false);
  }
}