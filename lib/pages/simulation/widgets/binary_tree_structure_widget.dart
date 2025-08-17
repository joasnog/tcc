import 'dart:async';
import 'package:awesome_side_sheet/Enums/sheet_position.dart';
import 'package:awesome_side_sheet/side_sheet.dart';
import 'package:flutter/material.dart';
import '../../../data_estructures/binary_tree.dart';
import '../../../data_estructures/data_structure.dart';
import '../../../models/node_position_model.dart';
import '../../../models/tree_node_model.dart';
import '../../../enums/tree_node_position.dart';
import '../../simulation/widgets/primary_button.dart';

class BinaryTreeStructureWidget extends StatefulWidget {
  final DataStructure dataStructure;

  const BinaryTreeStructureWidget({super.key, required this.dataStructure});

  @override
  State<BinaryTreeStructureWidget> createState() =>
      _BinaryTreeStructureWidgetState();
}

class _BinaryTreeStructureWidgetState extends State<BinaryTreeStructureWidget> {
  int maxDepth = 0;
  final TextEditingController _controller = TextEditingController();

  BinaryTreeStructure get tree => widget.dataStructure as BinaryTreeStructure;

  List<TreeNode> _animationNodes = [];
  int _activeNodeIndex = -1; // -1 = sem destaque
  Timer? _animationTimer;

  @override
  void dispose() {
    _animationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  int _autoValueCounter = 1;

  void _fillTreeAutomatically(TreeNode node, int currentDepth, int maxDepth) {
    if (currentDepth >= maxDepth) return;

    if (node.left == null) {
      final newValue = _autoValueCounter++;
      final newNode = TreeNode(value: newValue);
      node.left = newNode;
    }

    if (node.right == null) {
      final newValue = _autoValueCounter++;
      final newNode = TreeNode(value: newValue);
      node.right = newNode;
    }

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
      _stopAnimation();
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
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
      _stopAnimation();
    });
  }

  int _getTreeDepth(TreeNode? node) {
    if (node == null) return 0;
    return 1 +
        [
          _getTreeDepth(node.left),
          _getTreeDepth(node.right),
        ].reduce((a, b) => a > b ? a : b);
  }

  List<NodePosition> _buildNodePositions(
    TreeNode node,
    double x,
    double y,
    int level,
    double gapBase,
  ) {
    final gapX = gapBase * (1 << (maxDepth - level));
    List<NodePosition> positions = [];

    positions.add(NodePosition(node: node, x: x, y: y));

    if (node.left != null) {
      positions.addAll(
        _buildNodePositions(node.left!, x - gapX, y + 100, level + 1, gapBase),
      );
    } else if (level < 5) {
      positions.add(
        NodePosition(
          parent: node,
          x: x - gapX,
          y: y + 100,
          isPlaceholder: true,
          position: TreeNodePosition.left,
        ),
      );
    }

    if (node.right != null) {
      positions.addAll(
        _buildNodePositions(node.right!, x + gapX, y + 100, level + 1, gapBase),
      );
    } else if (level < 5) {
      positions.add(
        NodePosition(
          parent: node,
          x: x + gapX,
          y: y + 100,
          isPlaceholder: true,
          position: TreeNodePosition.right,
        ),
      );
    }

    return positions;
  }

  bool isActiveNode(TreeNode node) {
    if (_activeNodeIndex < 0 || _activeNodeIndex >= _animationNodes.length) {
      return false;
    }

    return _animationNodes[_activeNodeIndex].value == node.value;
  }

  void _startAnimation(List<TreeNode> nodes) {
    _animationTimer?.cancel();
    if (nodes.isEmpty) return;

    _animationNodes = nodes;
    _activeNodeIndex = 0;
    _historyNodes = [nodes[0]]; // começa o histórico com o primeiro nó
    _isAnimating = true;

    _animationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_activeNodeIndex < _animationNodes.length - 1) {
          _activeNodeIndex++;
          _historyNodes.add(
            _animationNodes[_activeNodeIndex],
          ); // adiciona o nó atual no histórico
        } else {
          timer.cancel();
          _activeNodeIndex = -1;
          _isAnimating = false;
        }
      });
    });

    setState(() {});
  }

  void _stopAnimation() {
    _animationTimer?.cancel();
    _activeNodeIndex = -1;
    _isAnimating = false;
    _historyNodes.clear(); // limpa histórico ao parar
    setState(() {});
  }

  List<TreeNode> _historyNodes = [];
  bool _isAnimating = false;
  bool _isOperationsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final nodes = <NodePosition>[];

    if (tree.items.isNotEmpty) {
      maxDepth = _getTreeDepth(tree.items.first);
      nodes.addAll(_buildNodePositions(tree.items.first, 1000, 40, 1, 30));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            tooltip: 'Explicação',
            onPressed: () {
              aweSideSheet(
                context: context,
                sheetPosition: SheetPosition.right,
                backgroundColor: Colors.white,
                showBackButton: false,
                showActions: false,
                showHeaderDivider: false,
                title: '',
                borderRadius: 16,
                footer: const SizedBox(),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        "Árvore (Tree)",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      SelectableText(
                        "Árvore é uma estrutura de dados que organiza as informações "
                        "de forma hierárquica, permitindo consultas rápidas e eficientes. "
                        "Ela reduz bastante a quantidade de comparações necessárias para "
                        "encontrar um valor.\n",
                        style: TextStyle(fontSize: 16),
                      ),
                      SelectableText(
                        "Um exemplo comum é a árvore de diretórios em um computador, "
                        "onde pastas (nós) podem conter outras pastas ou arquivos, "
                        "formando um diagrama hierarquizado.\n\n"
                        "Esse tipo de estrutura é muito usada em bancos de dados, "
                        "redes de computadores, linguística, mapas digitais, "
                        "sistemas de decisão e muitas outras áreas.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 12),
                      SelectableText(
                        "Componentes principais:\n"
                        "• Raiz: o nó inicial da árvore (onde tudo começa);\n"
                        "• Nós internos: podem ter filhos (outros nós ligados a ele);\n"
                        "• Folhas: nós sem filhos (grau zero);\n"
                        "• Grau de um nó: quantidade de filhos que ele possui;\n"
                        "• Grau da árvore: o maior grau entre todos os nós.\n",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 12),
                      SelectableText(
                        "Árvore Binária:\n"
                        "É a forma mais comum de árvore, onde cada nó pode ter "
                        "no máximo dois filhos: um à esquerda e um à direita. "
                        "Isso facilita a organização e a busca dos dados.\n",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 12),
                      SelectableText(
                        "Formas de percorrer os nós de uma árvore:\n"
                        "• In-order: visita nó da esquerda → raiz → direita. "
                        "Usado para acessar os dados de forma ordenada;\n"
                        "• Pre-order: visita raiz → esquerda → direita. "
                        "Revela a estrutura/topologia da árvore;\n"
                        "• Post-order: visita esquerda → direita → raiz. "
                        "Percorre dos filhos em direção à raiz.\n",
                        style: TextStyle(fontSize: 16),
                      ),
                      Divider(),
                      SelectableText(
                        "Referência: Instituto Federal de Santa Catarina - PRG29003: Introdução a árvores binárias\n"
                        "Disponível em: https://wiki.sj.ifsc.edu.br/index.php/PRG29003:_Introdu%C3%A7%C3%A3o_a_%C3%A1rvores_bin%C3%A1rias",
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: const Icon(Icons.info, color: Colors.white),
          ),
          SizedBox(height: 10),

          if (_isAnimating) ...[
            FloatingActionButton(
              heroTag: 'stop_animation',
              tooltip: 'Parar Animação',
              backgroundColor: Colors.red,
              onPressed: _stopAnimation,
              child: Icon(Icons.stop, color: Colors.white),
            ),
            // SizedBox(height: 10),
          ] else if (tree.items.isNotEmpty) ...[
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              child: _isOperationsExpanded
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10),
                        FloatingActionButton(
                          heroTag: 'preorder',
                          tooltip: 'Pré-ordem',
                          backgroundColor: Colors.deepPurple,
                          onPressed: () {
                            setState(() {
                              _isOperationsExpanded = false;
                              _startAnimation(tree.traversePreOrderList());
                            });
                          },
                          child: Text(
                            'Pré',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10),
                        FloatingActionButton(
                          heroTag: 'inorder',
                          tooltip: 'Em ordem',
                          backgroundColor: Colors.green,
                          onPressed: () {
                            setState(() {
                              _isOperationsExpanded = false;
                              _startAnimation(tree.traverseInOrderList());
                            });
                          },
                          child: Text(
                            'Em',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10),
                        FloatingActionButton(
                          heroTag: 'postorder',
                          tooltip: 'Pós-ordem',
                          backgroundColor: Colors.orange,
                          onPressed: () {
                            setState(() {
                              _isOperationsExpanded = false;
                              _startAnimation(tree.traversePostOrderList());
                            });
                          },
                          child: Text(
                            'Pós',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ),

            // SizedBox(height: 10),
            FloatingActionButton(
              tooltip: 'Operações',
              backgroundColor: Colors.black,
              onPressed: () {
                setState(() {
                  _isOperationsExpanded = !_isOperationsExpanded;
                });
              },
              child: Icon(Icons.play_arrow_rounded, color: Colors.white),
            ),
            SizedBox(height: 10),
          ],

          FloatingActionButton(
            tooltip: 'Preencher Árvore Automaticamente',
            backgroundColor: Colors.black,
            child: Icon(Icons.auto_graph, color: Colors.white),
            onPressed: () {
              setState(() {
                _autoValueCounter = 1;
                if (tree.root == null) {
                  tree.addRoot(_autoValueCounter++);
                }
                _fillTreeAutomatically(tree.root!, 1, 5);
                _stopAnimation();
              });
            },
          ),
        ],
      ),
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(2000),
        minScale: 0.2,
        maxScale: 2.5,
        child: SizedBox(
          width: 2000,
          height: 2000,
          child: Stack(
            children: [
              CustomPaint(
                painter: TreePainter(
                  nodes.where((n) => !n.isPlaceholder).toList(),
                ),
                child: Container(),
              ),
              ...nodes.map((node) {
                return Positioned(
                  left: node.x - 20,
                  top: node.y - 20,
                  child: node.isPlaceholder
                      ? IconButton(
                          onPressed: () => _addNode(
                            parent: node.parent,
                            position: node.position!,
                          ),
                          icon: Icon(Icons.add_circle, color: Colors.black),
                        )
                      : InkWell(
                          onTap: () => _confirmAndDeleteNode(node.node!),
                          child: TreeNodeWidget(
                            value: node.node!.value,
                            isActive: isActiveNode(node.node!),
                          ),
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
                      onPressed: () => _addNode(
                        parent: null,
                        position: TreeNodePosition.left,
                      ),
                      label: '+ Adicionar nó raiz',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _historyNodes.isNotEmpty
          ? Container(
              color: Colors.grey[200],
              height: 80,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _historyNodes.length,
                separatorBuilder: (_, __) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.arrow_right_alt_rounded),
                ),
                itemBuilder: (_, index) {
                  final node = _historyNodes[index];
                  final isActive = index == _historyNodes.length - 1;
                  return Container(
                    width: 28,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.redAccent : Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.7),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${node.value}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            )
          : null,
    );
  }
}

class TreeNodeWidget extends StatelessWidget {
  final int value;
  final bool isActive;

  const TreeNodeWidget({super.key, required this.value, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? Colors.redAccent : Colors.black,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.7),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
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
        canvas.drawLine(
          Offset(node.x, node.y),
          Offset(right.x, right.y),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant TreePainter oldDelegate) => true;
}
