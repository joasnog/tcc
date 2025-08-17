import 'package:awesome_side_sheet/Enums/sheet_position.dart';
import 'package:awesome_side_sheet/side_sheet.dart';
import 'package:flutter/material.dart';
import '../../../data_estructures/data_structure.dart';
import 'primary_button.dart';

class QueueStructureWidget extends StatefulWidget {
  final DataStructure dataStructure;

  const QueueStructureWidget({
    super.key,
    required this.dataStructure,
  });

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
      body: Center(
        child: SizedBox(
          height: 600,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
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
                                  int? value;
                                  if (_controller.text.isNotEmpty) {
                                    value = int.tryParse(_controller.text);
                                    if (value != null) {
                                      dataStructure.add(value);
                                      _controller.clear();
                                    }
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
              ),
      
              const SizedBox(width: 64),
      
              Align(
                alignment: Alignment.topCenter,
                child: Container(
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
                          ? [
                              const Text(
                                'Fila vazia',
                                style: TextStyle(color: Colors.grey),
                              )
                            ]
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
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
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
                  "Fila (Queue - FIFO)",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                SelectableText(
                  "São estruturas de dados do tipo FIFO (first-in first-out), "
                  "onde o primeiro elemento a ser inserido será o primeiro a ser retirado, "
                  "ou seja, adiciona-se itens no fim e remove-se do início.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SelectableText(
                  "Exemplos de uso:\n"
                  "• Controle de documentos para impressão;\n"
                  "• Troca de mensagens entre computadores numa rede;\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                SelectableText(
                  "A implementação de filas pode ser realizada através de vetor "
                  "(alocação do espaço de memória para os elementos é contígua) "
                  "ou através de listas encadeadas.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SelectableText(
                  "Operações principais:\n"
                  "• Criação da fila (informar a capacidade no caso de implementação sequencial - vetor);\n"
                  "• Enfileirar (enqueue) - o elemento é o parâmetro nesta operação;\n"
                  "• Desenfileirar (dequeue);\n"
                  "• Mostrar a fila (todos os elementos);\n"
                  "• Verificar se a fila está vazia (isEmpty);\n"
                  "• Verificar se a fila está cheia (isFull - vetor).\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                SelectableText(
                  "Obs: A remoção de um elemento da fila é realizada apenas "
                  "alterando-se a informação da posição do último.\n\n"
                  "Para evitar problemas de não ser capaz de inserir mais elementos "
                  "na fila, mesmo quando ela não está cheia, as referências primeiro "
                  "e último circundam até o início do vetor, resultando numa fila circular.",
                  style: TextStyle(fontSize: 16),
                ),
                Divider(),
                SelectableText(
                  "Referência: COS-121 - Estrutura de Dados e Algoritmos\n"
                  "Professor Ricardo Farias - UFRJ (2009)\n"
                  "Disponível em: https://www.cos.ufrj.br/~rfarias/cos121/filas.html",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        );
      },
      child: const Icon(Icons.info, color: Colors.white),
    ),

    );
  }
}