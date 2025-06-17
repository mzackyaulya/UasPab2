import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryRed = Colors.red.shade700;

    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔴 LOGO
                  Image.asset(
                    'assets/logo.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),

                  // 🔴 JUDUL
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryRed,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🔴 EMAIL
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email, color: primaryRed),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // 🔴 PASSWORD
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock, color: primaryRed),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  // 🔴 TOMBOL LOGIN
                  ElevatedButton(
                    onPressed: () => login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔴 LINK KE REGISTER
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterPage()),
                      );
                    },
                    child: Text(
                      "Belum punya akun? Daftar",
                      style: TextStyle(color: primaryRed),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
