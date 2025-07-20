import 'package:estruturas_de_dados/data_estructures/data_structure.dart';

import '../enums/tree_node_position.dart';
import '../models/tree_node_model.dart';

final class StackStructure implements DataStructure {
  @override
  String get id => 'stack';

  final List<int> _dados = [];

  @override
  void add(int? value) {
    _dados.add(value ?? _dados.length + 1);
  }

  @override
  void remove() {
    if (_dados.isEmpty) {
      throw Exception('A pilha está vazia.');
    }

    _dados.removeLast();
  }

  @override
  List get items => _dados;
  
  @override
  String get name => 'Pilha';
  
  @override
  void clearAll() {
    _dados.clear();
  }

  @override
  void addNode(int? value, {TreeNode? parent, required TreeNodePosition position}) {
    throw UnimplementedError('Método indisponível para pilha');
  }
}