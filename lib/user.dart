import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class User {
  final String id;
  final String nome;
  final String email;
  final String senha;
  final bool logado;

  final VoidCallback? onRegister;

  const User({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.logado = false,
    this.onRegister,
  });

  factory User.fromJson(String id, Map<String, dynamic> json) {
    return User(
      id: id,
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
    );
  }

  static Future<List<User>> carregarDados() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .get();

    return snapshot.docs
        .map((doc) => User.fromJson(doc.id, doc.data()))
        .toList();
  }

  static Future<void> addItem(User user) async {
    await FirebaseFirestore.instance.collection('usuarios').add({
      'id': user.id,
      'nome': user.nome,
      'email': user.email,
      'senha': user.senha,
      'logado': user.logado
    });
  }

  static Future<void> updateItem(String id, User user) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(id).update({
      'id': user.id,
      'nome': user.nome,
      'email': user.email,
      'senha': user.senha,
      'logado': user.logado
    });
  }

  static Future<void> deleteItem(String id) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(id).delete();
  }
}
