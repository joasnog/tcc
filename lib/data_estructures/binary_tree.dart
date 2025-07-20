import 'package:estruturas_de_dados/data_estructures/data_structure.dart';
import 'package:estruturas_de_dados/enums/tree_node_position.dart';

import '../models/tree_node_model.dart';

final class BinaryTreeStructure implements DataStructure {
  @override
  String get id => 'binary_tree';

  // Nó raiz
  final List<TreeNode> _items = [];

  @override
  void add(int? value) {
    throw UnimplementedError('Método indisponível para árvore binária');
  }

  @override
  void addNode(int? value, {TreeNode? parent, required TreeNodePosition position}) {
    if (value == null) return;

    TreeNode newNode = TreeNode(value: value);

    // Se não há parent, insere como raiz (ou adiciona à lista de raízes)
    if (parent == null) {
      _items.add(newNode);
      return;
    }

    // Adiciona como filho esquerdo ou direito
    switch (position) {
      case TreeNodePosition.left:
        if (parent.left != null) {
          throw Exception('O nó já possui filho à esquerda.');
        }
        parent.left = newNode;
        break;
      case TreeNodePosition.right:
        if (parent.right != null) {
          throw Exception('O nó já possui filho à direita.');
        }
        parent.right = newNode;
        break;
    }
  }


  @override
  void clearAll() {
    items.clear();
  }
  
  @override
  List<dynamic> get items => _items;

  @override
  String get name => 'Árvore Binária';

  @override
  void remove() {
  }

  void traversePreOrder() {}
 
  void traverseInOrder() {}
  
  void traversePostOrder() {}



}