import 'package:flutter/material.dart';
import '../data_estructures/binary_tree.dart';
import '../data_estructures/data_structure.dart';
import '../models/tree_node_model.dart';
import '../enums/tree_node_position.dart';

class BinaryTreeStructureWidget extends StatefulWidget {
  final DataStructure dataStructure;

  const BinaryTreeStructureWidget({
    super.key,
    required this.dataStructure,
  });

  @override
  State<BinaryTreeStructureWidget> createState() => _BinaryTreeStructureWidgetState();
}

class _BinaryTreeStructureWidgetState extends State<BinaryTreeStructureWidget> {
  final TextEditingController _controller = TextEditingController();

  BinaryTreeStructure get tree => widget.dataStructure as BinaryTreeStructure;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<int?> _showValueDialog() async {
    _controller.clear();
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Novo valor'),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Valor do nó'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(_controller.text);
              Navigator.pop(context, value);
            },
            child: Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _addNode({TreeNode? parent, required TreeNodePosition position}) async {
    final value = await _showValueDialog();
    if (value == null) return;

    setState(() {
      tree.addNode(value, parent: parent, position: position);
    });
  }

  List<_NodePosition> _buildNodePositions(TreeNode node, double x, double y, double gapX) {
    List<_NodePosition> positions = [];

    positions.add(_NodePosition(node: node, x: x, y: y));

    if (node.left != null) {
      positions.addAll(_buildNodePositions(node.left!, x - gapX, y + 100, gapX / 2));
    } else {
      positions.add(_NodePosition(parent: node, x: x - gapX, y: y + 100, isPlaceholder: true, position: TreeNodePosition.left));
    }

    if (node.right != null) {
      positions.addAll(_buildNodePositions(node.right!, x + gapX, y + 100, gapX / 2));
    } else {
      positions.add(_NodePosition(parent: node, x: x + gapX, y: y + 100, isPlaceholder: true, position: TreeNodePosition.right));
    }

    return positions;
  }

  @override
  Widget build(BuildContext context) {
    final nodes = <_NodePosition>[];

    if (tree.items.isNotEmpty) {
      nodes.addAll(_buildNodePositions(tree.items.first, MediaQuery.of(context).size.width / 2, 40, 120));
    }

    return Container(
      color: Colors.grey[900],
      width: double.infinity,
      height: 600,
      child: Stack(
        children: [
          CustomPaint(
            painter: TreePainter(nodes.where((n) => !n.isPlaceholder).toList()),
            child: Container(),
          ),
          ...nodes.map((node) {
            return Positioned(
              left: node.x - 20,
              top: node.y - 20,
              child: node.isPlaceholder
                  ? IconButton(
                      onPressed: () => _addNode(parent: node.parent, position: node.position!),
                      icon: Icon(Icons.add_circle, color: Colors.white),
                    )
                  : TreeNodeWidget(value: node.node!.value),
            );
          }),
          if (tree.items.isEmpty)
            Center(
              child: ElevatedButton(
                onPressed: () => _addNode(parent: null, position: TreeNodePosition.left),
                child: Text('+ Adicionar nó raiz'),
              ),
            ),
        ],
      ),
    );
  }
}

class TreeNodeWidget extends StatelessWidget {
  final int value;

  const TreeNodeWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blueGrey[300],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        '$value',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TreePainter extends CustomPainter {
  final List<_NodePosition> nodes;

  TreePainter(this.nodes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5;

    for (var node in nodes) {
      if (node.node?.left != null) {
        final left = nodes.firstWhere((n) => n.node == node.node!.left);
        canvas.drawLine(Offset(node.x, node.y), Offset(left.x, left.y), paint);
      }
      if (node.node?.right != null) {
        final right = nodes.firstWhere((n) => n.node == node.node!.right);
        canvas.drawLine(Offset(node.x, node.y), Offset(right.x, right.y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant TreePainter oldDelegate) => true;
}

class _NodePosition {
  final TreeNode? node;
  final TreeNode? parent;
  final TreeNodePosition? position;
  final bool isPlaceholder;
  final double x, y;

  _NodePosition({
    this.node,
    this.parent,
    this.position,
    required this.x,
    required this.y,
    this.isPlaceholder = false,
  });
}
