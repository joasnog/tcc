import 'package:awesome_side_sheet/Enums/sheet_position.dart';
import 'package:awesome_side_sheet/side_sheet.dart';
import 'package:flutter/material.dart';
import '../../../data_estructures/data_structure.dart';
import 'primary_button.dart';

class QueueStructureWidget extends StatefulWidget {
  final DataStructure dataStructure;

  const QueueStructureWidget({super.key, required this.dataStructure});

  @override
  State<QueueStructureWidget> createState() => _QueueStructureWidgetState();
}

class _QueueStructureWidgetState extends State<QueueStructureWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataStructure = widget.dataStructure;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          if (isMobile) {
            // 📱 Mobile: empilha verticalmente
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildLeftPanel(dataStructure),
                  const SizedBox(height: 32),
                  _buildRightPanel(dataStructure),
                ],
              ),
            );
          } else {
            // 💻 Desktop/Web: lado a lado
            return Center(
              child: SizedBox(
                height: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLeftPanel(dataStructure),
                    const SizedBox(width: 64),
                    _buildRightPanel(dataStructure),
                  ],
                ),
              ),
            );
          }
        },
      ),

      floatingActionButton: _buildInfoFab(context),
    );
  }

  Widget _buildLeftPanel(DataStructure dataStructure) {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Valor',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: PrimaryButton(
                    label: 'Push',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        int? value = int.tryParse(_controller.text);
                        if (value != null) {
                          dataStructure.add(value);
                          _controller.clear();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Pop',
                    backgroundColor: const Color(0xffF4F4F5),
                    textColor: Colors.black,
                    onPressed: () {
                      setState(() {
                        dataStructure.remove();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PrimaryButton(
                    label: 'Limpar',
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        dataStructure.clearAll();
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel(DataStructure dataStructure) {
    return Container(
      width: 600,
      height: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: dataStructure.items.isEmpty
              ? [const Text('Fila vazia', style: TextStyle(color: Colors.grey))]
              : dataStructure.items
                    .map(
                      (e) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Text(
                          e.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
        ),
      ),
    );
  }

  Widget _buildInfoFab(BuildContext context) {
    return FloatingActionButton(
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
                  "Fila (Queue)",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                SelectableText(
                  "Fila é uma estrutura de dados linear que segue o princípio FIFO “First-In, First-Out”, "
                  "ou seja, o primeiro elemento que entra é o primeiro que sai. É semelhante a uma fila de pessoas "
                  "aguardando atendimento.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SelectableText(
                  "Operações principais:\n"
                  "• Enqueue: adiciona um elemento ao final da fila;\n"
                  "• Dequeue: remove o elemento do início da fila;\n"
                  "• Peek/Front: consulta o primeiro elemento sem removê-lo;\n"
                  "• IsEmpty/Size: verifica se está vazia ou obtém o tamanho.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                SelectableText(
                  "Implementações comuns:\n"
                  "• Lista encadeada: eficiente para inserções e remoções em O(1), "
                  "mantendo ponteiros para início e fim;\n"
                  "• Vetor circular: utiliza um array e reaproveita espaço, útil em implementações com tamanho fixo.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                SelectableText(
                  "Aplicações práticas:\n"
                  "• Processamento de tarefas (como impressão ou mensagens);\n"
                  "• Gerenciamento de processos em sistemas operacionais (escalonamento FIFO);\n"
                  "• Algoritmos de busca em largura (BFS) em grafos;\n"
                  "• Filas de mensagens em sistemas distribuídos.\n",
                  style: TextStyle(fontSize: 16),
                ),
                Divider(),
                SelectableText(
                  "Referências:\n"
                  "- COS-121 (UFRJ): Filas definidas como estruturas FIFO com operações enqueue, dequeue, isEmpty, isFull e implementação por vetor circular ou lista encadeada. Disponível em: https://www.cos.ufrj.br/~rfarias/cos121/filas.html\n"
                  "- Aprenda Golang (Medium, Pedro Aquino, 26 maio 2025): explicação atualizada sobre fila (queue), operações básicas e exemplos de uso em gerenciamento de processos, impressão, buffers de rede, mensageria e BFS. Disponível em: https://medium.com/@pedro.vaf/fila-estrutura-din%C3%A2mica-ea280f4f1e9f\n",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        );
      },
      child: const Icon(Icons.info, color: Colors.white),
    );
  }
}
