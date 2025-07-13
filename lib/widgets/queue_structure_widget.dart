import 'package:flutter/material.dart';
import '../data_estructures/data_structure.dart';

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

    return Row(
      children: [
        // Lado esquerdo: input + botões
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Valor',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
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
                  child: const Text('Push'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dataStructure.remove();
                    });
                  },
                  child: const Text('Pop'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dataStructure.clearAll();
                    });
                  },
                  child: const Text('Limpar'),
                ),
              ],
            ),
          ),
        ),

        // Lado direito: fila visual
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue.shade50,
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
                              color: Colors.blue.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              e.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
    );
  }
}
