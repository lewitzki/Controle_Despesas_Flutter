import 'package:controle_de_despesas/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCXNacmKcMl4Y-BjGtCNFqrrnoy5hgeSmY",
      appId: "1:396508489432:web:f63dc5b6d96670650a19ad",
      messagingSenderId: "396508489432",
      projectId: "controle-de-despesas-6714f",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Despesas',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.black)),
      home: const RegisterPage(),
    );
  }
}
