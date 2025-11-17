import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_de_despesas/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrentUser {
  final String id;
  final VoidCallback? onLogin;

  const CurrentUser({required this.id, this.onLogin});

  factory CurrentUser.fromJson(String id, Map<String, dynamic> json) {
    return CurrentUser(id: id);
  }

  static Future<User?> findUserByEmail(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    return User.fromJson(doc.id, doc.data());
  }

  static Future<void> login(User user) async {
    await FirebaseFirestore.instance.collection('usuarios').doc('logado').set({
      'id': user.id,
      'nome': user.nome,
      'email': user.email,
      'senha': user.senha,
    });
  }

  static Future<void> logout(String id) async {
    await FirebaseFirestore.instance
        .collection('usuario_logado')
        .doc(id)
        .delete();
  }
}
