import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Expense extends StatelessWidget {
  final String id;
  final String descricao;
  final String categoria;
  final String data;
  final String valor;

  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const Expense({
    super.key,
    required this.id,
    required this.descricao,
    required this.categoria,
    required this.data,
    required this.valor,
    this.onEdit,
    this.onRemove,
  });

  factory Expense.fromJson(String id, Map<String, dynamic> json) {
    return Expense(
      id: id,
      descricao: json['descricao'],
      categoria: json['categoria'],
      data: json['data'],
      valor: json['valor']
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              descricao,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Categoria: $categoria'),
            Text('Data: $data'),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    TextButton(onPressed: onEdit, child: const Text('Editar')),
                    TextButton(
                      onPressed: onRemove,
                      child: const Text(
                        'Excluir',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
