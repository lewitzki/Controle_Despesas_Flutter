import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ExpenseTile> expenses = [
    ExpenseTile(
      id: '1',
      descricao: 'gasolina',
      categoria: 'transporte',
      data: '25/11/2025',
      valor: '50.0',
    ),
  ];

  void _addExpense() {
    setState(() {
      expenses.add(
        ExpenseTile(
          id: '2',
          descricao: 'marmita',
          categoria: 'comida',
          data: '31/02/2025',
          valor: '25.0',
        ),
      );
    });
  }

  void _editExpense(String id, ExpenseTile newExpense) {
    final index = expenses.indexWhere((e) => e.id == id);

    if (index != -1) {
      setState(() {
        expenses[index] = ExpenseTile(
          id: '2',
          descricao: 'marmita 02',
          categoria: 'comida',
          data: '31/02/2025',
          valor: '25.0',
        );
      });
    }
  }

  void _removeExpense(ExpenseTile value) {
    setState(() {
      expenses.remove(value);
    });
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
        onPressed: _addExpense,
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
                children: expenses.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return ExpenseTile(
                    id: item.id,
                    descricao: item.descricao,
                    categoria: item.categoria,
                    data: item.data,
                    valor: item.valor,
                    onEdit: () => _editExpense(item.id, item),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
