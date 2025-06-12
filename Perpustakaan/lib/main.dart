import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:perpustakaan/firebase_options.dart';
import 'package:perpustakaan/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Perpustakaan',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomePage(), // ganti sesuai halaman pertamamu
    );
  }
}
