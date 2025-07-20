import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StructureSelectionPage extends StatelessWidget {
  StructureSelectionPage({super.key});

  final structures = [
    _StructureData(
      name: 'Pilha',
      description: 'Estrutura LIFO (Primeiro a entrar, último a sair).',
      icon: Icons.vertical_align_top,
    ),
    _StructureData(
      name: 'Fila',
      description: 'Estrutura FIFO Primeiro a entrar, primeiro a sair).',
      icon: Icons.queue,

    ),
    _StructureData(
      name: 'Árvore Binária',
      description: 'Estrutura hierárquica com nós ligados por ramos.',
      icon: Icons.account_tree,
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha a Estrutura'),
      ),
      body: ListView.builder(
        itemCount: structures.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final structure = structures[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        structure.icon, 
                        size: 32, 
                        color: Colors.teal,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        structure.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(structure.description),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.go('/simulation/${structure.name.toLowerCase()}');
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Ver Simulação'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StructureData {
  final String name;
  final String description;
  final IconData icon;

  const _StructureData({
    required this.name,
    required this.description,
    required this.icon,
  });
}
