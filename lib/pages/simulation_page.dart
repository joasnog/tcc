import 'package:estruturas_de_dados/data_estructures/binary_tree.dart';
import 'package:estruturas_de_dados/data_estructures/stack.dart';
import 'package:estruturas_de_dados/widgets/binary_tree_structure_widget.dart';
import 'package:estruturas_de_dados/widgets/stack_structure_widget.dart';
import 'package:flutter/material.dart';

import '../data_estructures/data_structure.dart';
import '../data_estructures/queue.dart';
import '../widgets/queue_structure_widget.dart';
// import '../data_estructures/queue.dart';
// import '../widgets/queue_structure_widget.dart';

class SimulationPage extends StatelessWidget {
  final String? type;

  const SimulationPage({super.key, this.type});

  DataStructure? _resolveStructure() {
    switch (type) {
      case 'pilha': return StackStructure();
      case 'fila': return QueueStructure();
      case 'árvore binária': return BinaryTreeStructure();
      default:
        return null;
    }
  }

  Widget? _buildWidgetForStructure(DataStructure structure) {
    switch (structure.name.toLowerCase()) {
      case 'pilha': return StackStructureWidget(dataStructure: structure);
      case 'fila': return QueueStructureWidget(dataStructure: structure);
      case 'árvore binária': return BinaryTreeStructureWidget(dataStructure: structure);
      default: return const Center(child: Text('Visualização não implementada'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final structure = _resolveStructure();

    if (structure == null) {
      return const Scaffold(
        body: Center(child: Text('Estrutura inválida ou não encontrada')),
      );
    }

    final widget = _buildWidgetForStructure(structure);

    return Scaffold(
      appBar: AppBar(title: Text(structure.name)),
      body: widget,
    );
  }
}
