import 'package:controle_de_despesas/current-user.dart';
import 'package:controle_de_despesas/home.dart';
import 'package:controle_de_despesas/login.dart';
import 'package:controle_de_despesas/user.dart';
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

  final User? logado = await CurrentUser.getUserLoggedIn();
  final page = (logado == null) ? LoginPage() : HomePage();

  runApp(MyApp(page));
}

class MyApp extends StatelessWidget {
  final Widget page;
  const MyApp(this.page, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Despesas',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.green)),
      home: page,
    );
  }
}
