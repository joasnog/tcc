import 'package:awesome_side_sheet/Enums/sheet_position.dart';
import 'package:awesome_side_sheet/side_sheet.dart';
import 'package:flutter/material.dart';
import '../../../data_estructures/data_structure.dart';
import 'primary_button.dart';

class StackStructureWidget extends StatefulWidget {
  final DataStructure dataStructure;

  const StackStructureWidget({super.key, required this.dataStructure});

  @override
  State<StackStructureWidget> createState() => _StackStructureWidgetState();
}

class _StackStructureWidgetState extends State<StackStructureWidget> {
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
            children: [
              // Lado esquerdo fixo
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

              // Lado direito: visual da pilha fixo
              SizedBox(
                width: 300,
                height: 600,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: dataStructure.items.isEmpty
                          ? [
                              const Text(
                                'Pilha vazia',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ]
                          : dataStructure.items
                                .map(
                                  (e) => Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    width: double.infinity,
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
                                .toList()
                                .reversed
                                .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Botão flutuante com "i"
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
            footer: SizedBox(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    "Pilha (Stack - LIFO)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  SelectableText(
                    "São estruturas de dados do tipo LIFO (last-in first-out), "
                    "onde o último elemento a ser inserido será o primeiro a ser retirado.\n\n"
                    "Uma pilha permite acesso apenas ao último elemento inserido. "
                    "Para processar o penúltimo item, deve-se remover o último.\n",
                    style: TextStyle(fontSize: 16),
                  ),
                  SelectableText(
                    "Exemplos de uso:\n"
                    "• Funções recursivas em compiladores;\n"
                    "• Mecanismo de desfazer/refazer em editores de texto;\n"
                    "• Navegação entre páginas Web;\n",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  SelectableText(
                    "Operações principais:\n"
                    "• Criação da pilha;\n"
                    "• Empilhar (push);\n"
                    "• Desempilhar (pop);\n"
                    "• Mostrar o topo;\n"
                    "• Verificar se está vazia (isEmpty);\n"
                    "• Verificar se está cheia (isFull - vetor).\n",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  SelectableText(
                    "Obs: A remoção é feita apenas alterando a posição do topo.\n",
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(),
                  SelectableText(
                    "Referência: COS-121 - Estrutura de Dados e Algoritmos\n"
                    "Professor Ricardo Farias - UFRJ (2009)\n"
                    "Disponível em: https://www.cos.ufrj.br/~rfarias/cos121/pilhas.html",
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
