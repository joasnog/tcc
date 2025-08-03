import 'package:estruturas_de_dados/pages/simulation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import '../../../data_estructures/binary_tree.dart';
import '../../../data_estructures/data_structure.dart';
import '../../../models/node_position_model.dart';
import '../../../models/tree_node_model.dart';
import '../../../enums/tree_node_position.dart';

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
  int maxDepth = 0;
  final TextEditingController _controller = TextEditingController();

  BinaryTreeStructure get tree => widget.dataStructure as BinaryTreeStructure;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _autoValueCounter = 1;

  void _fillTreeAutomatically(TreeNode node, int currentDepth, int maxDepth) {
    if (currentDepth >= maxDepth) return;

    // Adiciona filho à esquerda, se não houver
    if (node.left == null) {
      final newValue = _autoValueCounter++;
      final newNode = TreeNode(value: newValue);
      node.left = newNode;
    }

    // Adiciona filho à direita, se não houver
    if (node.right == null) {
      final newValue = _autoValueCounter++;
      final newNode = TreeNode(value: newValue);
      node.right = newNode;
    }

    // Recursão nos filhos
    if (node.left != null) {
      _fillTreeAutomatically(node.left!, currentDepth + 1, maxDepth);
    }

    if (node.right != null) {
      _fillTreeAutomatically(node.right!, currentDepth + 1, maxDepth);
    }
  }

  Future<void> _confirmAndDeleteNode(TreeNode node) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remover nó'),
        content: Text('Tem certeza que deseja remover o nó ${node.value}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      tree.removeNode(node);
    });
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

  int _getTreeDepth(TreeNode? node) {
    if (node == null) return 0;
    return 1 + [
      _getTreeDepth(node.left),
      _getTreeDepth(node.right),
    ].reduce((a, b) => a > b ? a : b);
  }

  List<NodePosition> _buildNodePositions(TreeNode node, double x, double y, int level, double gapBase) {
    final gapX = gapBase * (1 << (maxDepth - level));
    List<NodePosition> positions = [];

    positions.add(NodePosition(node: node, x: x, y: y));

    if (node.left != null) {
      positions.addAll(_buildNodePositions(node.left!, x - gapX, y + 100, level + 1, gapBase));
    } else if (level < 5) { // <-- Limite máximo para exibir botão
      positions.add(NodePosition(
        parent: node,
        x: x - gapX,
        y: y + 100,
        isPlaceholder: true,
        position: TreeNodePosition.left,
      ));
    }

    if (node.right != null) {
      positions.addAll(_buildNodePositions(node.right!, x + gapX, y + 100, level + 1, gapBase));
    } else if (level < 5) { // <-- Mesmo aqui
      positions.add(NodePosition(
        parent: node,
        x: x + gapX,
        y: y + 100,
        isPlaceholder: true,
        position: TreeNodePosition.right,
      ));
    }

    return positions;
  }

  @override
  Widget build(BuildContext context) {
    final nodes = <NodePosition>[];

    if (tree.items.isNotEmpty) {
      maxDepth = _getTreeDepth(tree.items.first);
    }

    if (tree.items.isNotEmpty) {
      nodes.addAll(_buildNodePositions(tree.items.first, 1000, 40, 1, 30));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Preencher Árvore Automaticamente',
        backgroundColor: Colors.black,
        child: Icon(Icons.auto_graph, color: Colors.white),
        onPressed: () {
          setState(() {
            _autoValueCounter = 1;

            // Cria raiz se necessário
            if (tree.root == null) {
              tree.addRoot(_autoValueCounter++);
            }

            // Preenche a árvore
            _fillTreeAutomatically(tree.root!, 1, 5);
          });
        },
      ),
      body: InteractiveViewer(
        constrained: false, // Permite que o conteúdo ultrapasse os limites
        boundaryMargin: const EdgeInsets.all(2000), // Espaço livre para mover
        minScale: 0.2,
        maxScale: 2.5,
        child: SizedBox(
          width: 2000, // Área grande para a árvore
          height: 2000,
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
                          icon: Icon(Icons.add_circle, color: Colors.black),
                        )
                      : GestureDetector(
                          onLongPress: () => _confirmAndDeleteNode(node.node!),
                          child: TreeNodeWidget(value: node.node!.value),
                        ),
                );
              }),
      
              if (tree.items.isEmpty)
                Center(
                  child: SizedBox(
                    height: 60,
                    width: 160,
                    child: PrimaryButton(
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      onPressed: () => _addNode(parent: null, position: TreeNodePosition.left),
                      label: '+ Adicionar nó raiz',
                    ),
                  ),
                ),
            ],
          ),
        ),
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
        color: Colors.black,
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
  final List<NodePosition> nodes;

  TreePainter(this.nodes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1.0;

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