import 'dart:math';

import 'package:flutter/material.dart';

String generateNumericId({int length = 5}) {
  final rand = Random();
  return List.generate(length, (_) => rand.nextInt(10).toString()).join();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ExpenseTile> expenses = [];

  void _createOrUpdate(bool isCreate, ExpenseTile expense) {
    setState(() {
      if (isCreate) {
        _createExpense(expense);
      } else {
        _editExpense(expense.id, expense);
      }
    });
  }

  void _createExpense(ExpenseTile expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  void _editExpense(String id, ExpenseTile newExpense) {
    final index = expenses.indexWhere((e) => e.id == id);

    if (index != -1) {
      setState(() {
        expenses[index] = newExpense;
      });
    }
  }

  void _removeExpense(ExpenseTile value) {
    setState(() {
      expenses.remove(value);
    });
  }

  void showExpenseForm({ExpenseTile? expense}) {
    final descricaoController = TextEditingController(
      text: expense?.descricao ?? '',
    );
    final categoriaController = TextEditingController(
      text: expense?.categoria ?? '',
    );
    final dataController = TextEditingController(text: expense?.data ?? '');
    final valorController = TextEditingController(text: expense?.valor ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(expense == null ? 'Nova Despesa' : 'Editar Despesa'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                ),
                TextField(
                  controller: categoriaController,
                  decoration: InputDecoration(labelText: 'Categoria'),
                ),
                TextField(
                  controller: dataController,
                  decoration: InputDecoration(labelText: 'Data'),
                ),
                TextField(
                  controller: valorController,
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final isCreate = (expense == null);
                final content = ExpenseTile(
                  id: isCreate ? generateNumericId() : expense.id,
                  descricao: descricaoController.text,
                  categoria: categoriaController.text,
                  data: dataController.text,
                  valor: valorController.text,
                );
                _createOrUpdate(isCreate, content);
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Controle de Despesas',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: showExpenseForm,
        child: const Icon(Icons.add, size: 30),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Total no período filtrado',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'R\$ 150,00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildRoundedCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: _inputDecoration('Mês'),
                            items: const [
                              DropdownMenuItem(
                                value: 'Todos',
                                child: Text('Todos'),
                              ),
                              DropdownMenuItem(
                                value: '11',
                                child: Text('Novembro'),
                              ),
                              DropdownMenuItem(
                                value: '12',
                                child: Text('Dezembro'),
                              ),
                            ],
                            onChanged: (v) {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: _inputDecoration('Categoria'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    TextField(decoration: _inputDecoration('Buscar descrição')),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text('Filtrar'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text('Limpar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Despesas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Column(
                children: expenses.map((item) {
                  return ExpenseTile(
                    id: item.id,
                    descricao: item.descricao,
                    categoria: item.categoria,
                    data: item.data,
                    valor: item.valor,
                    onEdit: () => showExpenseForm(expense: item),
                    onRemove: () => _removeExpense(item),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  static Widget _buildRoundedCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }
}

class ExpenseTile extends StatelessWidget {
  final String id;
  final String descricao;
  final String categoria;
  final String data;
  final String valor;

  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const ExpenseTile({
    super.key,
    required this.id,
    required this.descricao,
    required this.categoria,
    required this.data,
    required this.valor,
    this.onEdit,
    this.onRemove,
  });

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
