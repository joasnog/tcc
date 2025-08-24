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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700; // define breakpoint

          if (isMobile) {
            // 📱 Layout empilhado no mobile
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildLeftPanel(dataStructure), // inputs/botões
                  const SizedBox(height: 32),
                  _buildRightPanel(dataStructure), // visualização
                ],
              ),
            );
          } else {
            // 💻 Layout lado a lado no desktop
            return Center(
              child: SizedBox(
                height: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
    return SizedBox(
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
                          margin: const EdgeInsets.symmetric(vertical: 4),
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
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Explicação aqui..."),
          ),
        );
      },
      child: const Icon(Icons.info, color: Colors.white),
    );
  }
}
