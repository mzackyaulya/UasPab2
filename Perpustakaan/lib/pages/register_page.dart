import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void register(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'nama': nameController.text.trim(),
        'email': emailController.text.trim(),
        'telepon': phoneController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registrasi berhasil")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi gagal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryRed = Colors.red.shade700;

    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🔴 LOGO
                 Image.asset(
                  'assets/logo.png',
                    height: 120,
                    fit: BoxFit.contain,
),
                  const SizedBox(height: 16),

                  // 🔴 JUDUL
                  Text("Buat Akun Baru",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryRed,
                      )),
                  const SizedBox(height: 24),

                  // 🔴 NAMA
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, color: primaryRed),
                    ),
                  ),
                  const SizedBox(height: 16),

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
                  const SizedBox(height: 16),

                  // 🔴 TELEPON
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'No. Telepon',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone, color: primaryRed),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),

                  // 🔴 TOMBOL REGISTER
                  ElevatedButton(
                    onPressed: () => register(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
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
