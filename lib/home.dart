import 'dart:math';
import 'package:controle_de_despesas/current-user.dart';
import 'package:controle_de_despesas/expense.dart';
import 'package:controle_de_despesas/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  double valorTotal = 0;
  List<Expense> expenses = [];
  List<Expense> expensesFiltrados = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  void carregar() async {
    expenses = await Expense.carregarDados();
    valorTotal = expenses.fold(0.0, (soma, item) => soma + item.valor);
    expensesFiltrados = expenses;
    setState(() {});
  }

  void filtrar(String value) {
    setState(() {
      expensesFiltrados = expenses
          .where(
            (item) =>
                item.descricao.toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
    });
  }

  void _createOrUpdate(bool isCreate, Expense expense) {
    setState(() {
      if (isCreate) {
        Expense.addItem(expense);
      } else {
        Expense.updateItem(expense.id, expense);
      }
      carregar();
    });
  }

  void _removeExpense(Expense expense) {
    setState(() {
      Expense.deleteItem(expense.id);
      carregar();
    });
  }

  void showExpenseForm({Expense? expense}) {
    final descricaoController = TextEditingController(
      text: expense?.descricao ?? '',
    );
    final categoriaController = TextEditingController(
      text: expense?.categoria ?? '',
    );
    final dataController = TextEditingController(text: expense?.data ?? '');
    final valorController = TextEditingController(
      text: (expense?.valor)?.toString() ?? '',
    );

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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Valor',
                    prefixText: 'R\$ ',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
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
                final content = Expense(
                  id: isCreate ? generateNumericId() : expense.id,
                  descricao: descricaoController.text,
                  categoria: categoriaController.text,
                  data: dataController.text,
                  valor: double.parse(valorController.text),
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
        backgroundColor: Colors.green,
        title: const Text(
          'Controle de Despesas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await CurrentUser.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
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
                  children: [
                    Text(
                      'Total no período filtrado',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'R\$ $valorTotal',
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

              TextField(
                decoration: InputDecoration(
                  labelText: "Buscar",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  filtrar(value);
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Despesas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Column(
                children: expenses.isEmpty
                    ? [
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Nenhuma despesa cadastrada',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]
                    : expensesFiltrados.map((item) {
                        return Expense(
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
}
