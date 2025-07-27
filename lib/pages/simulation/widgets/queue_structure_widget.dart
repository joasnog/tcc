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

    return Center(
      child: SizedBox(
        height: 600,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
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

            SizedBox(width: 64),
        
            // Lado direito: fila visual
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 600,
                height: 70,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
            ),
        
          ],
        ),
      ),
    );
  }
}
