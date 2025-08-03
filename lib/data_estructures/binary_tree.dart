import 'package:estruturas_de_dados/data_estructures/data_structure.dart';
import 'package:estruturas_de_dados/enums/tree_node_position.dart';
import '../models/tree_node_model.dart';

final class BinaryTreeStructure implements DataStructure {
  final List<TreeNode> _items = [];

  @override
  String get id => 'binary_tree';

  @override
  String get name => 'Árvore Binária';

  @override
  List<dynamic> get items => _items;

  /// Retorna o nó raiz da árvore (ou null se não houver)
  TreeNode? get root => _items.isNotEmpty ? _items.first : null;

  /// Retorna a profundidade máxima da árvore
  int get maxDepth => _getDepth(root);

  int _getDepth(TreeNode? node) {
    if (node == null) return 0;
    return 1 + [
      _getDepth(node.left),
      _getDepth(node.right),
    ].reduce((a, b) => a > b ? a : b);
  }

  /// Adiciona o nó raiz, se ainda não existir
  void addRoot(int value) {
    if (_items.isEmpty) {
      _items.add(TreeNode(value: value));
    } else {
      throw Exception('A árvore já possui um nó raiz.');
    }
  }

  @override
  void add(int? value) {
    throw UnimplementedError('Método indisponível para árvore binária');
  }

  @override
  void addNode(int? value, {TreeNode? parent, required TreeNodePosition position}) {
    if (value == null) return;
    TreeNode newNode = TreeNode(value: value);

    // Se for nó raiz
    if (parent == null) {
      addRoot(value);
      return;
    }

    // Se for filho
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
  void clearAll() => _items.clear();

  @override
  void remove() {
    // Ainda não implementado
  }

  // Dentro de BinaryTreeStructure
  void removeNode(TreeNode target) {
    if (root == target) {
      _items.clear(); // remove a raiz inteira
      return;
    }

    void _remove(TreeNode? parent) {
      if (parent == null) return;

      if (parent.left == target) {
        parent.left = null;
      } else if (parent.right == target) {
        parent.right = null;
      } else {
        _remove(parent.left);
        _remove(parent.right);
      }
    }

    _remove(root);
  }

  // Métodos futuros para percursos
  void traversePreOrder() {}

  void traverseInOrder() {}
  
  void traversePostOrder() {}
}
