import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_de_despesas/expense.dart';

class Firebase {
  static Future<List<Expense>> carregarDados() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('despesas')
        .get();

    return snapshot.docs
        .map((doc) => Expense.fromJson(doc.id, doc.data()))
        .toList();
  }

  static Future<void> addItem(Expense expense) async {
    await FirebaseFirestore.instance.collection('despesas').add({
      'id': expense.id,
      'descricao': expense.descricao,
      'categoria': expense.categoria,
      'data': expense.data,
      'valor': expense.valor
    });
  }

  static Future<void> updateItem(String id, Expense expense) async {
    await FirebaseFirestore.instance.collection('despesas').doc(id).update({
      'id': expense.id,
      'descricao': expense.descricao,
      'categoria': expense.categoria,
      'data': expense.data,
      'valor': expense.valor
    });
  }

  static Future<void> deleteItem(String id) async {
    await FirebaseFirestore.instance.collection('despesas').doc(id).delete();
  }
}