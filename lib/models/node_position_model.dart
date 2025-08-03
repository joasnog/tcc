import '../enums/tree_node_position.dart';
import 'tree_node_model.dart';

class NodePosition {
  final TreeNode? node;
  final TreeNode? parent;
  final TreeNodePosition? position;
  final bool isPlaceholder;
  final double x, y;

  NodePosition({
    this.node,
    this.parent,
    this.position,
    required this.x,
    required this.y,
    this.isPlaceholder = false,
  });
}
